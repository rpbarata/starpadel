# frozen_string_literal: true

module Clients
  class MovementsController < ClientController
    def index
      @breadcrumbs = [
        { text: "Home", href: root_path },
        { text: "Vouchers", href: clients_vouchers_path },
        { text: "Movimentos", href: clients_voucher_movements_path },
      ]

      @voucher = current_client.vouchers.find(params[:voucher_id])
      @movements = @voucher.movements
    end
  end
end
