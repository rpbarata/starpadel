# frozen_string_literal: true

module Clients
  class MovementsController < ApplicationController
    add_breadcrumb "Home", :root_path
    add_breadcrumb "Vouchers", :clients_vouchers_path
    add_breadcrumb "Movimentos", :clients_voucher_movements_path

    before_action :authenticate_client!

    def index
      @voucher = current_client.vouchers.find(params[:voucher_id])
      @movements = @voucher.movements
    end
  end
end
