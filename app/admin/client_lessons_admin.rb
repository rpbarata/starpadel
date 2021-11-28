# frozen_string_literal: true

Trestle.resource(:client_lessons, model: ClientLesson) do
  authorize_with cancan: Ability

  remove_action :destroy

  table do
    column :start_time
    column :end_time
    actions do |toolbar, _instance, _admin|
      toolbar.edit
      toolbar.show
    end
  end

  form dialog: true do |client_lesson|
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
          options_from_collection_for_select(LessonsType.actives.order(name: :asc), :id, :name, instance.lessons_type_id),
          include_blank: "Escolha um tipo de aula", disabled: !client_lesson.new_record?
      end
    end

    unless client_lesson.new_record?
      row do
        col(sm: 6) { datetime_field :start_time }
        col(sm: 6) { datetime_field :end_time }
      end
    end

    editor :comments
  end

  controller do
    include FixActionUpdateConcern

    def show
      super

      @hide_breadcrumbs = true
    end
  end
end
