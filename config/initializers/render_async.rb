# frozen_string_literal: true

RenderAsync.configure do |config|
  config.jquery = true # This will render jQuery code, and skip Vanilla JS code
  config.turbolinks = true # Enable this option if you are using Turbolinks 5+
end
