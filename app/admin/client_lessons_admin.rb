# frozen_string_literal: true

Trestle.resource(:client_lessons, model: ClientLesson) do
  authorize_with cancan: Ability

  menu do
    item :aulas, icon: "far fa-calendar-alt", priority: 3
  end

  search do |query|
    if query
      collection.joins(:client).where("clients.name ILIKE :q", q_id: query&.to_i, q: "%#{query}%")
    end
  end

  collection do
    ClientLesson.includes([:client, :lessons_type]).all.order(lesson_group: :desc)
  end

  table do
    column :client
    column :lessons_type, sort: false
    column :lesson_group
    column :start_time
    column :end_time
    actions do |toolbar, _instance, _admin|
      toolbar.edit
      toolbar.show
    end
  end

  form do |client_lesson|
    row do
      if params[:client_id].present?
        hidden_field :client_id, value: params[:client_id]
      else
        col(sm: 12) do
          select :client_id, options_from_collection_for_select(Client.all.order(name: :asc), :id, :name, instance.client_id),
            include_blank: "Escolha um cliente", disabled: !client_lesson.new_record?
        end
      end
    end

    row do
      col(sm: 12) do
        select :lessons_type_id,
          options_from_collection_for_select(LessonsType.actives.order(name: :asc), :id, :name, instance.lessons_type_id), include_blank: "Escolha um tipo de aula", disabled: !client_lesson.new_record?
      end
    end

    unless client_lesson.new_record?
      row do
        col(sm: 6) { datetime_field :start_time }
        col(sm: 6) { datetime_field :end_time }
      end
    end

    editor :comments
  end

  sort_column(:client) do |collection, order|
    collection.reorder("clients.name #{order} NULLS LAST")
  end

  controller do
    include FixActionUpdateConcern

    def create
      if client_lesson_params[:client_id].present? && client_lesson_params[:lessons_type_id].present? && (instance = Client.find(client_lesson_params[:client_id])) && ClientLesson.generate(
        client_lesson_params[:client_id], client_lesson_params[:lessons_type_id], client_lesson_params[:comments]
      )
        respond_to do |format|
          format.html do
            flash[:message] =
              flash_message("create.success", title: "Success!",
message: "The %{lowercase_model_name} was successfully created.")
            # redirect_to clients_admin_path(Client.find(client_lesson_params[:client_id]))
            redirect_to_return_location(:create, instance, default: clients_admin_path(instance))
          end
          format.json { render(json: instance, status: :created, location: clients_admin_path(instance)) }

          yield format if block_given?
        end
      else
        respond_to do |format|
          format.html do
            flash.now[:error] =
              flash_message("create.failure", title: "Warning!", message: "Please correct the errors below.")
            render("new", status: :unprocessable_entity)
          end
          format.json { render(json: instance.errors, status: :unprocessable_entity) }

          yield format if block_given?
        end
      end
    end

    private

    def client_lesson_params
      params.require(:client_lesson).permit(:client_id, :lessons_type_id, :comments)
    end
  end
end
