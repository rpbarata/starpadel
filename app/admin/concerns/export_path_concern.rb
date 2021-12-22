# frozen_string_literal: true

module ExportPathConcern
  extend ActiveSupport::Concern

  def export_clients_params(params)
    export_params = params.permit!.slice(:q, :scope)

    export_params.to_query
  end

  def export_client_lessons_params(params)
    export_params = params.permit!.slice(:client, :coach, :start_date, :end_date)

    export_params.to_query
  end
end
