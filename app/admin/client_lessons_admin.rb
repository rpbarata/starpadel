# frozen_string_literal: true

Trestle.resource(:client_lessons, model: ClientLesson) do
  authorize_with cancan: Ability

  remove_action :destroy, :show

  table(autolink: false) do
    column :start_time
    column :end_time
    column :coach_admin

    actions do |toolbar, instance, _admin|
      if instance.client.present?
        toolbar.link("Registar", instance, action: :edit, style: :success, date: { behavior: "dialog" },
          icon: "far fa-calendar-check")
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
  end

  controller do
    def edit
      super
    end

    def update
      if update_instance
        respond_to do |format|
          format.html do
            flash[:message] =
              flash_message("update.success",
                title: "Success!",
                message: "The %{lowercase_model_name} was successfully updated.")
            # redirect_to_return_location(:update, instance, default: admin.instance_path(instance))
            redirect_to(credited_lessons_admin_path(instance.credited_lesson))
            # render(:edit, status: :ok)
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
  end
end
