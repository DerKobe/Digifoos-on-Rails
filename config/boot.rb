ENV['RAILS_ENV'] ||= 'development'
ENV['DATABASE_URL'] = "postgres://postgres@localhost/digifoos_#{ENV['RAILS_ENV']}"

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])
