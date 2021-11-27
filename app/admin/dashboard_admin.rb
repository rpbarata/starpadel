# frozen_string_literal: true

Trestle.admin(:dashboard) do
  menu do
    item :dashboard, icon: "fa fa-tachometer", priority: 1
  end

  controller do
    before_action :set_clients,
      only: [:clients_line_chart, :clients_pie_chart, :index, :clients_members_pie_chart,
             :adults_and_childrens_pie_chart, :lessons_type_pie_chart]

    def clients_pie_chart
      @clients_pie_chart = {
        "Sócios": @clients.members_of_club.size,
        "Não Sócios": @clients.not_members_of_club.size,
      }

      render(json: @clients_pie_chart)
    end

    def clients_line_chart
      @clients_line_chart = [
        { name: "Adesão Total de Clientes", data: @clients.group_by_day(:created_at).size },
        { name: "Adesão de Novos Sócios", data: @clients.members_of_club.group_by_day(:become_member_at).size },
      ]

      render(json: @clients_line_chart.chart_json)
    end

    def clients_members_pie_chart
      @clients_members_pie_chart = {
        "Sócios": @clients.members_of_club.size,
        "Sócios Master": @clients.master_members.size,
      }

      render(json: @clients_members_pie_chart.chart_json)
    end

    def adults_and_childrens_pie_chart
      @adults_and_childrens_pie_chart = {
        "Adultos": @clients.adults.size,
        "Crianças": @clients.childrens.size,
      }

      render(json: @adults_and_childrens_pie_chart.chart_json)
    end

    # def lessons_type_pie_chart
    #   temp = ClientLesson.joins(:lessons_type).group("client_lessons.lesson_group", "lessons_types.name").count

    #   render(json: @lessons_type_pie_chart.chart_json)
    # end

    private

    def set_clients
      start_date = params[:start_date]&.in_time_zone
      end_date = params[:end_date]&.in_time_zone

      @clients = Client.select_by_date(start_date, end_date)
    end
  end

  routes do
    get :clients_pie_chart, as: "clients_pie_chart"
    get :clients_line_chart, as: "clients_line_chart"
    get :clients_members_pie_chart, as: "clients_members_pie_chart"
    get :adults_and_childrens_pie_chart, as: "adults_and_childrens_pie_chart"
    # get :lessons_type_pie_chart, as: "lessons_type_pie_chart"
  end
end
