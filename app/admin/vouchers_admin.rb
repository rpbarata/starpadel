# frozen_string_literal: true

Trestle.resource(:vouchers, model: Voucher) do
  authorize_with cancan: Ability

  remove_action :destroy

  menu do
    item :vouchers, icon: "fas fa-gift", priority: 4
  end

  collection do
    Voucher.includes([:client]).all.order(created_at: :desc)
  end

  search do |query|
    if query
      collection.where("code ILIKE :q", q_id: query&.to_i, q: "%#{query}%")
    else
      collection
    end
  end

  table do
    column :client, link: true, class: "media-title-column"
    column :code
    column :value, ->(voucher) { number_to_currency(voucher.value) }
    column :created_at, sort: { default: true, default_order: :desc }
    column :validity

    actions do |toolbar, _instance, _admin|
      toolbar.show
      toolbar.edit
    end
  end

  sort_column(:client) do |collection, order|
    collection.reorder("clients.name #{order} NULLS LAST")
  end

  form do |voucher|
    row do
      col(sm: 12) do
        select :client_id,
          options_from_collection_for_select(Client.all.order(name: :asc), :id, :name, instance.client_id || params[:client_id]),
          include_blank: "Escolha um cliente", disabled: params[:client_id].present? || !voucher.new_record?
      end
    end

    row do
      col(sm: 6) do
        number_field :value, min: 0, step: 0.01, prepend: icon("fas fa-euro-sign"), disabled: !voucher.new_record?
      end
      col(sm: 6) { datetime_field :validity }
    end

    editor :comments

    hidden_field :from_client, value: params[:from_client]
    if params[:client_id].present?
      hidden_field :client_id, value: params[:client_id]
    end
  end

  controller do
    include FixActionUpdateConcern

    # before_action :load_instance,
    #   only: [:show, :edit, :update, :destroy, :movement_modal, :update_movement_modal]

    def show
      super

      @movements = instance.movements
    end

    def create
      if save_instance
        # if params[:voucher][:client_id].present?
        #   instance = Client.find(params[:voucher][:client_id])
        # end
        respond_to do |format|
          format.html do
            flash[:message] =
              flash_message("create.success", title: "Success!",
message: "The %{lowercase_model_name} was successfully created.")
            if params[:voucher][:from_client].present?
              redirect_to("#{clients_admin_path(params[:voucher][:client_id])}#!tab-vouchers")
            else
              redirect_to(vouchers_admin_index_path)
            end
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
