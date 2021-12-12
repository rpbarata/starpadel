# frozen_string_literal: true

Trestle.resource(:credited_lessons, model: CreditedLesson) do
  authorize_with cancan: Ability

  remove_action :destroy, :update, :edit

  menu do
    item :"Aulas Creditadas", icon: "far fa-calendar-alt", priority: 3
  end

  scopes do
    scope :all, default: true,  label: t("activerecord.scopes.default")
    scope :green_time,          label: t("activerecord.scopes.credited_lesson.green_time")
    scope :red_time,            label: t("activerecord.scopes.credited_lesson.red_time")
  end

  # search do |query|
  #   if query
  #     collection.joins(:client).where("clients.name ILIKE :q", q_id: query&.to_i, q: "%#{query}%")
  #   end
  # end

  collection do
    CreditedLesson.includes([:client, :lessons_type]).all.order(created_at: :desc)
  end

  table(autolink: false) do
    column :client, link: false, class: "media-title-column" do |lesson|
      if lesson.client.present?
        link_to(lesson.client.name, clients_admin_path(lesson.client))
      else
        content_tag(:span, "Cliente Apagado", class: "blank")
      end
    end
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
      lesson.paid? ? status_tag("Pago", :success) : lesson.payment_left_str
    end

    actions do |toolbar, instance, _admin|
      if (current_user.super_admin? || current_user.secretariat_admin?) && !instance.paid? && instance.client.present?
        toolbar.link("Pagar", instance, action: :payment_modal, style: :success, data: { behavior: "dialog" })
      end
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
          options_from_collection_for_select(
            Client.all.order(name: :asc),
            :id,
            :name,
            instance.client_id || params[:client_id]
          ),
          include_blank: "Escolha um cliente", disabled: params[:client_id].present?
      end
      # end
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
        select :time_period,
          CreditedLesson.defined_enums["time_period"].keys.map { |status|
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

      initialize_credited_lessons_filters if @collection.present?
    end

    def show
      super

      client_lesson_group = instance
      @lessons = client_lesson_group.client_lessons.order(created_at: :desc)
    end

    def update_payment_modal
      instance.new_payment = payment_modal_params[:new_payment]
      instance.add_payment(payment_modal_params)

      movement_is_valid = true
      if payment_modal_params[:voucher_id].present?
        movement_is_valid = instance.create_movement(payment_modal_params[:voucher_id],
          payment_modal_params[:new_payment].to_d)
        unless movement_is_valid
          instance.errors.add(:new_payment, "ultrapassa o valor do voucher")
        end
      end

      if movement_is_valid && instance.save
        flash[:message] = "Pagamento Registado"
      else
        @errors = instance.errors
      end
    end

    private

    def payment_modal_params
      params.require(:credited_lesson).permit(:new_payment, :voucher_id)
    end
  end

  routes do
    member do
      get :payment_modal
      patch :update_payment_modal
    end
  end
end
