# frozen_string_literal: true

module Clients
  class VouchersController < ClientController
    def index
      @breadcrumbs = [
        { text: "Home", href: root_path },
        { text: "Vouchers", href: clients_vouchers_path },
      ]

      @vouchers = current_client.vouchers
    end
  end
end
