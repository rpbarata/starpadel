# frozen_string_literal: true

module ExportPathConcern
  extend ActiveSupport::Concern

  def export_clients_params(params)
    export_params = params.permit!.slice(:q, :scope)

    export_params.to_query
  end
end
