# frozen_string_literal: true

module Clients
  class VouchersController < ApplicationController
    add_breadcrumb "Home", :root_path
    add_breadcrumb "Vouchers", :clients_vouchers_path

    before_action :authenticate_client!

    def index
      @vouchers = current_client.vouchers
    end
  end
end
