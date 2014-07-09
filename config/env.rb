# This file contains the ENV vars necessary to run the app locally.
# Some of these values are sensitive, and some are developer specific.
#
# DO NOT CHECK THIS FILE INTO VERSION CONTROL

ENV['RAILS_ENV']    ||= 'development'
ENV['DATABASE_URL'] ||= "postgres://postgres@localhost/digifoos_#{ENV['RAILS_ENV']}"
