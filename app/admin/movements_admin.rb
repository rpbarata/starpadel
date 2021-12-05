# frozen_string_literal: true

Trestle.resource(:movements, model: Movement) do
  authorize_with cancan: Ability

  remove_action :destroy

  menu do
    item :movements, icon: "fa fa-star"
  end

  collection do
    Movement.includes([:voucher, :client]).all.order(date: :desc)
  end

  table do
    column :client, link: true, class: "media-title-column"
    column :voucher, link: true, class: "media-title-column" do |movement|
      movement.voucher.code
    end
    column :value, ->(movement) { number_to_currency(movement.value) }
    column :date, sort: { default: true, default_order: :desc }
    column :description

    actions do |toolbar, _instance, _admin|
      toolbar.show
    end
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
          options_from_collection_for_select(Voucher.all.order(code: :asc), :id, :code,
            instance.voucher_id || params[:voucher_id]),
          include_blank: "Escolha um voucher",
          disabled: params[:voucher_id].present? || instance.voucher_id.present?
      end
      col(sm: 6) { number_field :value, min: 0, step: 0.01, prepend: icon("fas fa-euro-sign") }
    end

    row(class: "mt-3") do
      col(sm: 6) { check_box :from_client_lessons_group }
    end

    row(id: "movement_lesson_row", style: "display: none") do
      col(sm: 12) do
        select :client_lessons_group_id,
          options_from_collection_for_select(
            ClientLessonsGroup.includes([:client,
                                         :lessons_type,]).get(instance.client_id || params[:client_id]), :id, :formated_str, instance.client_lessons_group_id || params[:client_lessons_group_id]
          ),
          include_blank: "Escolha uma aula",
          disabled: params[:client_lessons_group_id].present? || instance.client_lessons_group_id.present?
      end
    end

    row(id: "movement_description_row") do
      col(sm: 12) { text_field :description }
    end

    editor :comments

    if params[:voucher_id].present?
      hidden_field :voucher_id, value: params[:voucher_id]
    end
    if params[:client_id].present?
      hidden_field :client_id, value: params[:client_id]
    end
  end

  controller do
    include FixActionUpdateConcern
  end
end
