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

  collection do
    Client.all.order(name: :asc)
  end

  scopes do
    scope :all, default: true, label: t("activerecord.scopes.default")
    scope :members_of_club, label: t("activerecord.scopes.clients.members_of_club")
    scope :not_members_of_club, label: t("activerecord.scopes.clients.not_members_of_club")
    scope :master_members, label: t("activerecord.scopes.clients.master_members")
    scope :adults, label: t("activerecord.scopes.clients.adults")
    scope :childrens, label: t("activerecord.scopes.clients.childrens")
  end

  # Customize the table columns shown on the index view.
  #
  table(autolink: false) do
    column :name, link: true, sort: { default: true, default_order: :asc }, class: "media-title-column"
    column :member_of_club, align: :center do |client|
      if client.member_id.present?
        status_tag(icon("fa fa-check"), :success)
      else
        status_tag(icon("fa fa-times"), :danger)
      end
    end
    column :is_master_member, align: :center do |client|
      if client.is_master_member
        status_tag(icon("fa fa-check"), :success)
      else
        status_tag(icon("fa fa-times"), :danger)
      end
    end
    column :is_adult, align: :center do |client|
      if client.birth_date.blank?
        "Sem Data de Nascimento"
      elsif client.adult?
        status_tag(icon("fa fa-check"), :success)
      else
        status_tag(icon("fa fa-times"), :danger)
      end
    end

    actions do |toolbar, _instance, _admin|
      toolbar.edit
      toolbar.show
    end
  end

  # Customize the form fields shown on the new/edit views.
  #
  form do |client|
    text_field :name

    row do
      col(sm: 6) { text_field :email }
      col(sm: 6) { text_field :phone_number }
    end

    text_field :address

    row do
      col(sm: 6) do
        row do
          col { text_field :member_id }
        end
        row do
          col { check_box :is_master_member, disabled: client.member_id.blank? }
        end
      end
      col(sm: 6) { text_field :fpp_id }
    end

    row do
      col(sm: 4) { text_field :identification_number }
      col(sm: 4) { text_field :nif }
      col(sm: 4) { date_field :birth_date }
    end

    editor :comments
  end

  controller do
    include FixActionUpdateConcern
    include TrestleFiltersConcern
    include ExportPathConcern

    def index
      super

      if current_user.super_admin? || current_user.secretariat_admin?
        @export = {
          path: export_clients_admin_index_path,
          params: export_clients_params(params),
          text: "Exportar Clientes",
        }
      end
    end

    def show
      super

      client = instance
      @credited_lessons = client.credited_lessons.includes([:lessons_type]).order(created_at: :desc)
      @vouchers = client.vouchers.order(created_at: :desc)

      initialize_credited_lessons_filters

      @tabs = [
        { tab_id: "tab-client", tab_name: "client", record: client.as_json, instance: instance },
        { tab_id: "tab-credited_lessons", tab_name: "credited_lessons",
          records: @credited_lessons.page(params[:page]).per(50), trestle_class: CreditedLessonsAdmin,
          filters: @filter_dropdown_lists, search: true, filter_dates: @filter_dates,
          button_path: new_credited_lessons_admin_path(client_id: instance.id), button_text: "Creditar",
          button_behavior: "dialog", },
      ]

      if current_user.super_admin? || current_user.secretariat_admin?
        @tabs << {
          tab_id: "tab-vouchers", tab_name: "vouchers", records: @vouchers.page(params[:page]).per(50),
          trestle_class: VouchersAdmin, button_path: new_vouchers_admin_path(client_id: instance.id, from_client: true),
          button_text: "Adicionar", button_behavior: "dialog",
        }
      end
    end

    def export
      @collection = Client.all

      @collection = @collection.where("name ILIKE :q", q: "%#{params[:q]}%") if params[:q].present?

      if params[:scope].present?
        case params[:scope]
        when "members_of_club"
          @collection = @collection.members_of_club
        when "not_members_of_club"
          @collection = @collection.not_members_of_club
        when "master_members"
          @collection = @collection.master_members
        when "adults"
          @collection = @collection.adults
        when "childrens"
          @collection = @collection.childrens
        end
      end

      filename = Exports::ClientsXlsxJob.perform_now(@collection.pluck(:id))

      send_file(filename, disposition: "attachment", type: "application/xlsx")
    end
  end

  routes do
    get :export, on: :collection
  end
end
