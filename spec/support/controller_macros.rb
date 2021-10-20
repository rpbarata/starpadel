# frozen_string_literal: true

module ControllerMacros
  def login_admin
    before do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in(create(:admin))
    end
  end
end
