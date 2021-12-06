# frozen_string_literal: true

Trestle.resource(:client_lessons_groups, model: ClientLessonsGroup) do
  authorize_with cancan: Ability

  remove_action :destroy, :update, :edit

  menu do
    item :"Aulas Creditadas", icon: "far fa-calendar-alt", priority: 3
  end

  scopes do
    scope :all, default: true,  label: t("activerecord.scopes.default")
    scope :green_time,          label: t("activerecord.scopes.client_lessons_group.green_time")
    scope :red_time,            label: t("activerecord.scopes.client_lessons_group.red_time")
  end

  # search do |query|
  #   if query
  #     collection.joins(:client).where("clients.name ILIKE :q", q_id: query&.to_i, q: "%#{query}%")
  #   end
  # end

  collection do
    ClientLessonsGroup.includes([:client, :lessons_type]).all.order(created_at: :desc)
  end

  table(autolink: false) do
    column :client, link: true, class: "media-title-column"
    column :lessons_type, sort: false, link: true, class: "media-title-column" do |lesson|
      link_to(lesson.lessons_type.name, lessons_type_admin_path(lesson.lessons_type))
    end
    column :time_period do |lesson|
      if lesson.time_period.present?
        status_tag(I18n.t("activerecord.enums.time_period.#{lesson.time_period}"),
          lesson.green_time? ? :success : :danger)
      end
    end
    column :created_at, sort: { default: true, default_order: :desc }
    column :remaining_lessons_str, align: :center, sort: false
    column :payment_left_str, sort: false do |lesson|
      if lesson.paid?
        status_tag("Pago", :success)
      else
        lesson.payment_left_str
      end
    end

    actions do |toolbar, instance, _admin|
      toolbar.link("Pagar", instance, action: :payment_modal,
        params: { index_params: params.to_enum.to_h.merge(from: request.controller_class.to_s) },
        style: :success, data: { behavior: "dialog" }) unless instance.paid?
      toolbar.show
    end
  end

  sort_column(:client) do |collection, order|
    collection.reorder("clients.name #{order} NULLS LAST")
  end

  form do |client_lesson|
    row do
      if params[:client_id].present?
        hidden_field :client_id, value: params[:client_id]
      end
      col(sm: 12) do
        select :client_id,
          options_from_collection_for_select(Client.all.order(name: :asc), :id, :name, instance.client_id || params[:client_id]),
          include_blank: "Escolha um cliente", disabled: params[:client_id].present?
      end
      # end
    end

    row do
      col(sm: 12) do
        select :lessons_type_id,
          options_from_collection_for_select(LessonsType.actives.order(name: :asc), :id, :name, instance.lessons_type_id),
          include_blank: "Escolha um tipo de aula", disabled: !client_lesson.new_record?
      end
    end

    row do
      col(sm: 12) do
        select :time_period,
          ClientLessonsGroup.defined_enums["time_period"].keys.map { |status|
            [I18n.t("activerecord.enums.time_period.#{status}"), status]
          }
      end
    end

    editor :comments
  end

  controller do
    include FixActionUpdateConcern
    include TrestleFiltersConcern

    before_action :load_instance,
      only: [:show, :edit, :update, :destroy, :payment_modal, :update_payment_modal]

    def index
      super

      initialize_client_lessons_groups_filters if @collection.present?
    end

    def show
      super

      client_lesson_group = instance
      @lessons = client_lesson_group.client_lessons.order(created_at: :desc)
    end

    def update_payment_modal
      instance.new_payment = payment_modal_params[:new_payment]
      # instance.voucher_id = payment_modal_params[:voucher_id]
      instance.add_payment(payment_modal_params)

      
      movement_is_valid = true
      if(payment_modal_params[:voucher_id].present?)
        movement_is_valid = instance.create_movement(payment_modal_params[:voucher_id], payment_modal_params[:new_payment].to_d)
        unless movement_is_valid
          instance.errors.add(:new_payment, "ultrapassa o valor do voucher")
        end
      end

      if movement_is_valid && instance.save
        flash[:message] = "Pagamento Registado"
        render_url =
          if params[:client_lessons_group][:index_params][:from] == "ClientLessonsGroupsAdmin::AdminController"
            if params[:client_lessons_group][:index_params][:action] == "index"
              client_lessons_groups_admin_index_path
            elsif params[:client_lessons_group][:index_params][:action] == "show"
              client_lessons_group_id = params[:client_lessons_group][:index_params][:id]
              client_lessons_groups_admin_path(client_lessons_group_id)
            end
          elsif params[:client_lessons_group][:index_params][:from] == "ClientsAdmin::AdminController"
            client_id = params[:client_lessons_group][:index_params][:id]
            "#{clients_admin_path(client_id)}/#!tab-credited_lessons"
          end

        respond_to do |format|
          format.js { render(js: "window.location.href='" + render_url + "'") }
        end
      else
        @errors = instance.errors
        render("admin/client_lessons_groups/update_payment_modal.js")
        nil
      end
    end

    private

    def payment_modal_params
      params.require(:client_lessons_group).permit(:new_payment, :voucher_id)
    end
  end

  routes do
    member do
      get :payment_modal
      patch :update_payment_modal
    end
  end
end
