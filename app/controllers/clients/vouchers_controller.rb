# frozen_string_literal: true

module Clients
  class VouchersController < ClientController
    def index
      @breadcrumbs = [
        { text: "Home", href: root_path },
        { text: "Vouchers", href: clients_vouchers_path },
      ]

      @vouchers = current_client.vouchers.page(params[:page])

      index_apply_filters
      index_set_filter_array

      if params[:code].present?
        @vouchers = @vouchers.where("code ILIKE ?", "%#{params[:code]}%")
      end
    end

    private

    def index_set_filter_array
      @filters_drop_down_array = [
        { name: "validity", label: "Validade",
          options: [["Todos", nil], ["Válidos", "valid"], ["Expirados", "expired"]], },
      ]
    end

    def index_apply_filters
      if params[:code].present?
        @vouchers = @vouchers.where("code ILIKE ?", "%#{params[:code]}%")
      end

      if params[:validity].present?
        case params[:validity]
        when "valid"
          @vouchers = @vouchers.not_expired
        when "expired"
          @vouchers = @vouchers.expired
        end
      end
    end
  end
end
