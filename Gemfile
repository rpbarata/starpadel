# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.2"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem "rails", "~> 6.1.4", ">= 6.1.4.1"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use Puma as the app server
gem "puma", "~> 5.0"
# Use SCSS for stylesheets
gem "sass-rails", ">= 6"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", "~> 5.0"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
gem "image_processing", "~> 1.2"
gem "active_storage_validations"
gem "mini_magick", ">= 4.9.5"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.4", require: false

# Load environment variables from .env
gem "dotenv-rails"

# Better Rails logs
gem "amazing_print", "~> 1.2", ">= 1.2.2"
gem "rails_semantic_logger", "~> 4.4", ">= 4.4.4"

gem "devise"
gem "devise-i18n"

gem "trestle"
gem "trestle-auth", github: "TrestleAdmin/trestle-auth", branch: "authorization",
  ref: "7d164117a60ffb46f657c721874c01950c64a566"
gem "trestle-tinymce"
gem "trestle-search"
gem "trestle-sidekiq"
gem "trestle-active_storage"

gem "paper_trail", "~> 11.1"
gem "paper_trail-globalid", "~> 0.2.0"

gem "chartkick", "~> 3.4", ">= 3.4.2"
gem "groupdate", "~> 5.2", ">= 5.2.2"

gem "phonelib"

gem "sentry-ruby"
gem "sentry-rails"
gem "sentry-sidekiq"

# Authorization
gem "cancancan", "~> 3.2", ">= 3.2.1"

gem "faker" # This is not save to be in where.

gem "render_async"

gem "write_xlsx"

gem "sidekiq"
gem "sidekiq-scheduler"

gem "mailjet"

gem "maily"

gem "font-awesome-rails"

gem "kaminari"

gem "aws-sdk-s3", require: false

group :development, :test do
  gem "bullet"
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "factory_bot_rails"
  # gem "faker"
  gem "rspec-rails", "~> 4.0.1"
  gem "rubocop-faker"
  gem "rubocop-rspec", require: false
end

group :development do
  gem "brakeman"
  # preview emails in browser
  gem "letter_opener"
  gem "letter_opener_web", "~> 2.0"
  # To annotate models
  gem "annotate"
  # Ruby linting
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-shopify", require: false
  gem "rubocop-performance", require: false
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 4.1.0"
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem "rack-mini-profiler", "~> 2.0"
  gem "listen", "~> 3.3"
  gem "rails-erd"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver"
  gem "database_cleaner-active_record"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "webdrivers"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", "~> 1.2021", ">= 1.2021.1"

# GEMS TO INVESTIGATE
# https://github.com/zdennis/activerecord-import
