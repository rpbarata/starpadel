# frozen_string_literal: true

Trestle.resource(:client_lessons, model: ClientLesson) do
  authorize_with cancan: Ability

  remove_action :destroy, :new, :create, :show

  menu do
    item :"Marcação de Aulas", icon: "far fa-calendar-alt", priority: 5
  end

  collection do
    current_user.client_lessons.includes([:client, :coach_admin]).order(:start_time)
  end

  table(autolink: false) do
    column :client, link: false, class: "media-title-column" do |client_lesson|
      if client_lesson.client.present?
        link_to(client_lesson.client.name, clients_admin_path(client_lesson.client))
      else
        content_tag(:span, "Cliente Apagado", class: "blank")
      end
    end
    column :start_time
    column :end_time
    column :coach_admin
    column :status, align: :center, class: "hidden-xs" do |client_lesson|
      if client_lesson.to_schedule?
        status_tag(client_lesson.translate(:status), :default)
      elsif client_lesson.schedule?
        status_tag(client_lesson.translate(:status), :info)
      elsif client_lesson.done?
        status_tag(client_lesson.translate(:status), :success)
      elsif client_lesson.missed?
        status_tag(client_lesson.translate(:status), :danger)
      end
    end

    actions do |toolbar, instance, _admin|
      if instance.client.present?
        if instance.to_schedule? || instance.missed?
          toolbar.link("Agendar", instance, action: :edit, style: :warning, icon: "far fa-calendar-check", params: { from_client_lessons: true, status: :schedule },)
        elsif instance.schedule?
          toolbar.link("Realizada", instance, action: :edit, style: :success, icon: "fas fa-check", params: { from_client_lessons: true, status: :done },)
          toolbar.link("Faltou", instance, action: :missed, style: :danger, icon: "fas fa-times", method: :patch, params: { index_params: params.to_enum.to_h.merge(from: request.controller_class.to_s) },)
        end
      end
    end
  end

  # FIX: this should be a dialog. But something is wrong with the redirect
  form do |client_lesson|
    row do
      col(sm: 12) do
        select :client_id,
          options_from_collection_for_select(Client.all.order(name: :asc), :id, :name, instance.client_id),
          include_blank: "Escolha um cliente", disabled: !client_lesson.new_record?
      end
    end

    row do
      col(sm: 12) do
        select :lessons_type_id,
          options_from_collection_for_select(
            LessonsType.actives.order(name: :asc),
            :id,
            :name,
            instance.lessons_type_id
          ),
          include_blank: "Escolha um tipo de aula", disabled: !client_lesson.new_record?
      end
    end

    row do
      col(sm: 12) do
        select :coach_admin_id,
          options_from_collection_for_select(
            Admin.coach_admin.order(username: :asc),
            :id,
            :username,
            instance.coach_admin_id || (current_user.coach_admin? ? current_user.id : nil)
          ),
          include_blank: "Escolha um treinador",
          disabled: current_user.coach_admin?

        if current_user.coach_admin?
          hidden_field :coach_admin_id, value: current_user.id
        end
      end
    end

    unless client_lesson.new_record?
      row do
        col(sm: 6) { datetime_field :start_time }
        col(sm: 6) { datetime_field :end_time }
      end
    end

    # editor :comments
    hidden_field :from_client_lessons, value: params[:from_client_lessons]
    hidden_field :status, value: params[:status]
  end

  controller do
    include ExportPathConcern
    include TrestleFiltersConcern

    before_action :load_instance,
      only: [:edit, :update, :done, :missed,]

    def index
      initialize_client_lessons_filters if @collection.present?

      @export = {
        path: export_client_lessons_admin_index_path,
        params: export_client_lessons_params(params),
        text: "Exportar Aulas Realizadas",
      }
    end

    def update
      if update_instance
        # instance.schedule!
        respond_to do |format|
          format.html do
            flash[:message] =
              flash_message("update.success",
                title: "Success!",
                message: "The %{lowercase_model_name} was successfully updated.")

            redirect_url =
              if ActiveModel::Type::Boolean.new.cast(params[:client_lesson][:from_client_lessons].presence)
                client_lessons_admin_index_path
              else
                credited_lessons_admin_path(instance.credited_lesson)
              end

            redirect_to(redirect_url)
          end
          format.json { render(json: instance, status: :ok) }
          yield format if block_given?
        end
      else
        respond_to do |format|
          format.html do
            flash.now[:error] =
              flash_message("update.failure", title: "Warning!", message: "Please correct the errors below.")
            render("edit", status: :unprocessable_entity)
          end
          format.json { render(json: instance.errors, status: :unprocessable_entity) }

          yield format if block_given?
        end
      end
    end

    def export
      @collection = current_user.client_lessons.where(status: :done)

      initialize_client_lessons_filters

      filename = Exports::ClientLessonsXlsxJob.perform_now(@collection.pluck(:id))

      send_file(filename, disposition: "attachment", type: "application/xlsx")
    end

    def done
      instance.done!

      flash[:message] = { title: "Sucesso!", message: "Aula marcada como Realizada" }

      if params[:index_params][:from] == "ClientLessonsAdmin::AdminController"
        redirect_to(client_lessons_admin_index_path())
      elsif params[:index_params][:from] == "CreditedLessonsAdmin::AdminController"
        redirect_to(credited_lessons_admin_path(instance.credited_lesson))
      end
    end

    def missed
      instance.missed!

      flash[:message] = { title: "Sucesso!", message: "Aula marcada como Falta" }

      if params[:index_params][:from] == "ClientLessonsAdmin::AdminController"
        redirect_to(client_lessons_admin_index_path())
      elsif params[:index_params][:from] == "CreditedLessonsAdmin::AdminController"
        redirect_to(credited_lessons_admin_path(instance.credited_lesson))
      end
    end
  end

  routes do
    collection do
      get :export
    end

    member do
      patch :done
      patch :missed
    end
  end
end
