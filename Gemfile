# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Bootstrap makes things pretty
gem 'bootstrap_form', '~> 4.0'
gem 'bootstrap-sass'
gem 'font-awesome-rails', '~> 4.7', '>= 4.7.0.2'
gem 'sprockets-rails', require: 'sprockets/railtie'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.4'
# Use postgres as the database for Active Record
gem 'pg'
gem 'pg_search'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.x'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use devise for user auth
gem 'devise'
# Administrate for easy data tables
gem "administrate"

# Use Active Storage variant
gem "aws-sdk-s3", require: false
gem 'active_storage_validations'
gem 'image_processing', '~> 1.2'
gem "mini_magick"

#Paypal Plugin
gem 'paypal-checkout-sdk'

#Mailing List
gem 'MailchimpMarketing'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'rails-settings-cached', '~> 2.5'
