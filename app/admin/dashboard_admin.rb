# frozen_string_literal: true

Trestle.admin(:dashboard) do
  menu do
    item :dashboard, icon: "fa fa-tachometer", priority: 1
  end

  controller do
    before_action :set_clients, only: [:clients_line_chart, :clients_pie_chart, :index]

    def clients_pie_chart
      @clients_pie_chart = {
        "Sócios": @clients.members_of_club.size,
        "Não Sócios": @clients.not_members_of_club.size,
      }

      render(json: @clients_pie_chart)
    end

    def clients_line_chart
      # counting = 0
      # new_hash = {}
      # @clients.group_by_day(:created_at).size.each do |k, v|
      #   counting += v
      #   new_hash[k] = counting
      # end

      @clients_line_chart = [
        # { name: "Total Clients", data: new_hash },
        { name: "Adesão Total de Clientes", data: @clients.group_by_day(:created_at).size },
        { name: "Adesão de Novos Sócios", data: @clients.members_of_club.group_by_day(:become_member_at).size },
      ]

      render(json: @clients_line_chart.chart_json)
    end

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
  end
end
