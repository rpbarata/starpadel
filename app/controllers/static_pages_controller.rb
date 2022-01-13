# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def cookies_policy
    @breadcrumbs = [
      { text: "Home", href: root_path },
      { text: "Política de Cookies", href: cookies_policy_path },
    ]
  end
end
