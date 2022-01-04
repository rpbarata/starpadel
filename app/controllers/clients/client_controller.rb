# frozen_string_literal: true

module Clients
  class ClientController < ApplicationController
    before_action :authenticate_client!

    def index
      @breadcrumbs = [
        { text: "Home", href: root_path },
        { text: "Informações", href: clients_path },
      ]
    end
  end
end
