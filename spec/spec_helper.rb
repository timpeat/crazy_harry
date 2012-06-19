require 'rubygems'
require 'bundler'
require 'simplecov'

SimpleCov.start if ENV["COVERAGE"]

Bundler.require :default, :development

require 'rspec'

RSpec.configure do |config|
end
