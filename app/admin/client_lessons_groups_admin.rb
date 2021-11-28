# frozen_string_literal: true

Trestle.resource(:client_lessons_groups, model: ClientLessonsGroup) do
  authorize_with cancan: Ability

  remove_action :destroy, :update, :edit

  menu do
    item :"Aulas Creditadas", icon: "far fa-calendar-alt", priority: 3
  end

  search do |query|
    if query
      collection.joins(:client).where("clients.name ILIKE :q", q_id: query&.to_i, q: "%#{query}%")
    end
  end

  collection do
    ClientLessonsGroup.includes([:client, :lessons_type, :client]).all.order(created_at: :desc)
  end

  table do
    column :client, link: true, class: "media-title-column"
    column :lessons_type, sort: false, link: true, class: "media-title-column"
    column :created_at, sort: { default: true, default_order: :desc }

    actions do |toolbar, _instance, _admin|
      toolbar.show
    end
  end

  sort_column(:client) do |collection, order|
    collection.reorder("clients.name #{order} NULLS LAST")
  end

  form do |client_lesson|
    row do
      # if params[:client_id].present?
      #   hidden_field :client_id, value: params[:client_id]
      # else
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

    editor :comments
  end

  controller do
    include FixActionUpdateConcern

    def show
      super

      client_lesson_group = instance
      @lessons = client_lesson_group.client_lessons.order(created_at: :desc)
    end
  end
end
