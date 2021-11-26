# frozen_string_literal: true

Trestle.resource(:lessons_type, model: LessonsType) do
  authorize_with cancan: Ability

  menu do
    group :Administração, priority: :last do
      item :"Tipos de Aulas", icon: "fas fa-users", priority: 1
    end
  end

  search do |query|
    if query
      collection.where("name ILIKE :q", q_id: query&.to_i, q: "%#{query}%")
    end
  end

  collection do
    LessonsType.all.order(name: :asc)
  end

  scopes do
    scope :all, default: true, label: t("activerecord.scopes.default")
    scope :packs, label: t("activerecord.scopes.lessons_types.packs")
    scope :not_packs, label: t("activerecord.scopes.lessons_types.not_packs")
  end

  table do
    column :name, link: true, sort: { default: true, default_order: :asc }, class: "media-title-column"
    column :green_time_member_price, ->(lesson_type) {
                                       number_to_currency(lesson_type.green_time_member_price, unit: "€")
                                     }
    column :green_time_not_member_price, ->(lesson_type) {
                                           number_to_currency(lesson_type.green_time_not_member_price, unit: "€")
                                         }
    column :red_time_member_price, ->(lesson_type) { number_to_currency(lesson_type.red_time_member_price, unit: "€") }
    column :red_time_not_member_price, ->(lesson_type) {
                                         number_to_currency(lesson_type.red_time_not_member_price, unit: "€")
                                       }
    column :is_pack, align: :center do |lesson_type|
      if lesson_type.is_pack
        status_tag(icon("fa fa-check"), :success)
      else
        status_tag(icon("fa fa-times"), :danger)
      end
    end
    column :number_of_lessons, ->(lesson_type) { lesson_type.format_number_of_lessons }

    actions do |toolbar, _instance, _admin|
      toolbar.edit
      toolbar.show
    end
  end

  form do |lesson_type|
    text_field :name

    row do
      col(sm: 6) { number_field :green_time_not_member_price, min: 0, step: 0.01, prepend: "€" }
      col(sm: 6) { number_field :red_time_not_member_price, min: 0, step: 0.01, prepend: "€" }
    end

    row do
      col(sm: 6) { number_field :green_time_member_price, min: 0, step: 0.01, prepend: "€" }
      col(sm: 6) { number_field :red_time_member_price, min: 0, step: 0.01, prepend: "€" }
    end

    row do
      col(sm: 3, md: 2) { check_box :is_pack }
      col(sm: 6) { check_box :is_active }
    end

    row(id: "number_of_lessons_row", style: "visibility: #{lesson_type.is_pack ? "visible" : "hidden"}") do
      col(sm: 12) { number_field :number_of_lessons, min: 0, step: 1 }
    end

    editor :comments
  end

  controller do
    include FixActionUpdateConcern
  end
end