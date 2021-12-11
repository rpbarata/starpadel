# frozen_string_literal: true

module Trestle
  class ApplicationController < ActionController::Base
    protect_from_forgery
    before_action :set_paper_trail_whodunnit
    before_action :configure_permitted_parameters, if: :devise_controller?

    include Trestle::Controller::Breadcrumbs
    include Trestle::Controller::Callbacks
    include Trestle::Controller::Dialog
    include Trestle::Controller::Helpers
    include Trestle::Controller::Layout
    include Trestle::Controller::Location
    include Trestle::Controller::Title
    include Trestle::Controller::Toolbars

    def configure_permitted_parameters
      puts "################ OI ###################"
      devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
    end
  end
end
