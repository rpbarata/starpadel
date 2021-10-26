# frozen_string_literal: true

Trestle.admin(:dashboard) do
  menu do
    item :dashboard, icon: "fa fa-tachometer", priority: 1
  end

  controller do 
    def clients_pie_chart
      start_date = params[:start_date]&.in_time_zone
      end_date = params[:end_date]&.in_time_zone
      
      @client_pie_chart = {
        "Sócios": Client.select_by_date(start_date, end_date).members_of_club.count,
        "Não Sócios": Client.select_by_date(start_date, end_date).not_members_of_club.count
      }
    
      render json: @client_pie_chart
    end
  end

  routes do
    get :clients_pie_chart, as: "clients_pie_chart"
  end
end
