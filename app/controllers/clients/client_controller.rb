# frozen_string_literal: true

module Clients
  class ClientController < ApplicationController
    add_breadcrumb "Home", :root_path
    add_breadcrumb "Informações", :clients_path

    before_action :authenticate_client!

    def index; end
  end
end
