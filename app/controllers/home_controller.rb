# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @breadcrumbs = [
      { text: "Home", href: root_path },
    ]
  end
end
