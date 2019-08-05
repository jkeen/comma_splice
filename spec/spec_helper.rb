require 'bundler/setup'
Bundler.setup

require 'comma_splice' # and any other gems you need

def test_csv_path(name)
  File.join(File.expand_path('../', __FILE__), "test_csvs/#{name}")
end

def read_test_csv(name)
  File.read(test_csv_path(name), encoding: 'utf-8')
end


RSpec.configure do |config|
  # some (optional) config here
end
