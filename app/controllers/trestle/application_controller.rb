class Trestle::ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :set_paper_trail_whodunnit

  include Trestle::Controller::Breadcrumbs
  include Trestle::Controller::Callbacks
  include Trestle::Controller::Dialog
  include Trestle::Controller::Helpers
  include Trestle::Controller::Layout
  include Trestle::Controller::Location
  include Trestle::Controller::Title
  include Trestle::Controller::Toolbars
end