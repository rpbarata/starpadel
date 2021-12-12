# frozen_string_literal: true

module Trestle
  class ApplicationController < ActionController::Base
    protect_from_forgery
    before_action :set_paper_trail_whodunnit
    before_action :set_sentry_user

    include Trestle::Controller::Breadcrumbs
    include Trestle::Controller::Callbacks
    include Trestle::Controller::Dialog
    include Trestle::Controller::Helpers
    include Trestle::Controller::Layout
    include Trestle::Controller::Location
    include Trestle::Controller::Title
    include Trestle::Controller::Toolbars

    def set_sentry_user
      Sentry.set_user(username: current_user&.username, id: current_user&.id)
    end
  end
end
