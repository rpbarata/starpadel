# frozen_string_literal: true

Trestle.resource(:clients, model: Client) do
  authorize_with cancan: Ability

  menu do
    item :clientes, icon: "fas fa-user-friends", priority: 2
  end

  search do |query|
    if query
      collection.where("name ILIKE :q", q_id: query&.to_i, q: "%#{query}%")
    end
  end

  scopes do
    scope :all, default: true
    scope "Sócios", -> { collection.members_of_club }
    scope "Não Sócios", -> { collection.not_members_of_club }
  end

  # Customize the table columns shown on the index view.
  #
  table do
    column :name
    column :member_of_club, align: :center do |client|
      if client.member_id.present?
        status_tag(icon("fa fa-check"), :success)
      else
        status_tag(icon("fa fa-times"), :danger)
      end
    end
  end

  # Customize the form fields shown on the new/edit views.
  #
  form do |_client|
    text_field :name

    row do
      col(sm: 6) { text_field :email }
      col(sm: 6) { text_field :phone_number }
    end

    text_field :address

    row do
      col(sm: 6) { text_field :member_id }
      col(sm: 6) { text_field :fpp_id }
    end

    row do
      col(sm: 4) { text_field :identification_number }
      col(sm: 4) { text_field :nif }
      col(sm: 4) { date_field :birth_date }
    end

    editor :comments
  end
end
