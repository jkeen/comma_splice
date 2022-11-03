require 'bundler/setup'
Bundler.setup

require 'simplecov'
SimpleCov.start

require 'comma_splice' # and any other gems you need

def test_file_path(name)
  File.join(File.expand_path(__dir__), "test_csvs/#{name}")
end

def read_test_file(name)
  File.read(test_file_path(name), encoding: 'utf-8')
end

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
end
