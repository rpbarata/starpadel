# frozen_string_literal: true

Trestle.resource(:vouchers, model: Voucher) do
  authorize_with cancan: Ability

  remove_action :destroy, :edit

  menu do
    item :vouchers, icon: "fas fa-gift", priority: 4
  end

  collection do
    Voucher.includes([:client]).all.order(created_at: :desc)
  end

  scopes do
    scope :all, default: true, label: t("activerecord.scopes.default")
    scope :not_expired, label: t("activerecord.scopes.vouchers.not_expired")
    scope :fully_used, label: "Usados"
    scope :expired, label: t("activerecord.scopes.vouchers.expired")
  end

  search do |query|
    if query
      collection.where("code ILIKE :q", q_id: query&.to_i, q: "%#{query}%")
    end
  end

  table(autolink: false) do
    column :client, link: false, class: "media-title-column" do |voucher|
      if voucher.client.present?
        link_to(voucher.client.name, clients_admin_path(voucher.client))
      else
        content_tag(:span, "Cliente Apagado", class: "blank")
      end
    end
    column :code, class: "font-weight-bold"
    column :value, ->(voucher) { number_to_currency(voucher.value) }
    column :value_used, ->(voucher) { number_to_currency(voucher.value_used) }
    column :value_remaining, ->(voucher) { number_to_currency(voucher.value_remaining) }
    column :created_at, sort: { default: true, default_order: :desc }
    column :validity do |voucher|
      if voucher.validity.present?
        status_tag(voucher.validity, voucher.expired? ? :danger : :success)
      else
        "Sem validade"
      end
    end

    actions do |toolbar, _instance, _admin|
      toolbar.show
    end
  end

  sort_column(:client) do |collection, order|
    collection.reorder("clients.name #{order} NULLS LAST")
  end

  form do |voucher|
    row do
      col(sm: 12) do
        select :client_id,
          options_from_collection_for_select(
            Client.all.order(name: :asc),
            :id,
            :name,
            instance.client_id || params[:client_id]
          ),
          include_blank: "Escolha um cliente", disabled: params[:client_id].present? || !voucher.new_record?
      end
    end

    row do
      col(sm: 6) do
        number_field :value, min: 0, step: 0.01, prepend: icon("fas fa-euro-sign"), disabled: !voucher.new_record?
      end
      col(sm: 6) { datetime_field :validity }
    end

    # editor :comments

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

      @movements = instance.movements.includes([:client]).order(date: :desc)
    end

    def create
      if save_instance
        respond_to do |format|
          format.html do
            flash[:message] =
              flash_message("create.success", title: "Success!",
                message: "The %{lowercase_model_name} was successfully created.")
            if params[:voucher][:from_client].present?
              redirect_to("#{clients_admin_path(params[:voucher][:client_id])}#!tab-vouchers")
            else
              redirect_to_return_location(:create, instance, default: admin.instance_path(instance))
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
