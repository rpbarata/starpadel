# frozen_string_literal: true

Trestle.resource(:movements, model: Movement) do
  authorize_with cancan: Ability

  remove_action :destroy, :show

  # menu do
  #   item :movements, icon: "fa fa-star"
  # end

  collection do
    Movement.includes([:voucher, :client]).all.order(date: :desc)
  end

  table(autolink: false) do
    column :client, link: true, class: "media-title-column"
    column :voucher, link: false, class: "media-title-column" do |movement|
      movement.voucher.code
    end
    column :value, ->(movement) { number_to_currency(movement.value) }
    column :date, sort: { default: true, default_order: :desc }
    column :description
  end

  # # sort_column(:client) do |collection, order|
  # #   collection.reorder("clients.name #{order} NULLS LAST")
  # # end

  # sort_column(:voucher) do |collection, order|
  #   collection.reorder("voucher.code #{order} NULLS LAST")
  # end

  form dialog: true do |_movement|
    row do
      col(sm: 12) do
        select :client_id,
          options_from_collection_for_select(Client.all.order(name: :asc), :id, :name,
            instance.client_id || params[:client_id]),
          include_blank: "Escolha um client",
          disabled: params[:client_id].present? || instance.client_id.present?
      end
    end

    row do
      col(sm: 6) do
        select :voucher_id,
          options_from_collection_for_select(Voucher.all.order(code: :asc), :id, :format_srt,
            instance.voucher_id || params[:voucher_id]),
          include_blank: "Escolha um voucher",
          disabled: params[:voucher_id].present? || instance.voucher_id.present?
      end
      col(sm: 6) { number_field :value, min: 0, step: 0.01, prepend: icon("fas fa-euro-sign") }
    end

    row(class: "mt-3") do
      col(sm: 6) { check_box :from_credited_lesson }
    end

    row(id: "movement_lesson_row", style: "display: none") do
      col(sm: 12) do
        select :credited_lesson_id,
          options_from_collection_for_select(
            CreditedLesson.includes([:client, :lessons_type])
                          .get(instance.client_id || params[:client_id]),
            :id,
            :formated_str,
            instance.credited_lesson_id || params[:credited_lesson_id]
          ),
          include_blank: "Escolha uma aula",
          disabled: params[:credited_lesson_id].present? || instance.credited_lesson_id.present?
      end
    end

    row(id: "movement_description_row") do
      col(sm: 12) { text_field :description }
    end

    # editor :comments

    if params[:voucher_id].present? || instance.voucher_id.present?
      hidden_field :voucher_id, value: params[:voucher_id] || instance.voucher_id
    end
    if params[:client_id].present? || instance.client_id.present?
      hidden_field :client_id, value: params[:client_id] || instance.client_id
    end
  end

  controller do
    def create
      if save_instance
        respond_to do |format|
          format.html do
            flash[:message] =
              flash_message("create.success", title: "Success!",
                message: "The %{lowercase_model_name} was successfully created.")
            # redirect_to_return_location(:create, instance, default: admin.instance_path(instance))
            redirect_to(vouchers_admin_path(instance.voucher))
          end
          format.json { render(json: instance, status: :created, location: admin.instance_path(instance)) }

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
  end
end
