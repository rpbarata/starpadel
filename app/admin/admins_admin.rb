# frozen_string_literal: true

Trestle.resource(:admins, model: Admin) do

  remove_action :destroy

  menu do
    group :Administração, priority: :last do
      item :Administradores, icon: "fas fa-users"
    end
  end

  scopes do
    scope :all, default: true
    scope "Super Administradores", -> { collection.super_admin }
    scope "Balcão", -> { collection.secretariat_admin }
    scope "Treinador", -> { collection.coach_admin }
  end

  search do |query|
    if query
      collection.where("email ILIKE :q OR username ILIKE :q", q_id: query&.to_i, q: "%#{query}%")
    else
      collection
    end
  end

  table do
    column :username, link: true
    column :email, link: true
    column :role, ->(admin) { admin.translate(:role) }
  end

  form do |_admin|
    row do
      col(sm: 6) { text_field :username }
      col(sm: 6) { text_field :email }
    end
    select :role, Admin.defined_enums["role"].keys.map { |status|
                    [I18n.t("activerecord.enums.role_list.#{status}"), status]
                  }
    row do
      col(sm: 6) { password_field :password }
      col(sm: 6) { password_field :password_confirmation }
    end
  end
end
