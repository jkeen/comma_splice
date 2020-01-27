# frozen_string_literal: true

require 'csv'
require 'active_support/core_ext/string'
require 'comma_splice/version'
require 'comma_splice/helpers/content_finder'
require 'comma_splice/helpers/variable_column_finder'
require 'comma_splice/helpers/line'
require 'comma_splice/helpers/join_possibilities'
require 'comma_splice/helpers/comma_calculator'
require 'comma_splice/helpers/option_scorer'

require 'comma_splice/line_corrector'
require 'comma_splice/file_corrector'
require 'byebug'

module CommaSplice
  class Error < StandardError; end
  mattr_accessor :debug
end
