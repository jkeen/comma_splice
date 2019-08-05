# frozen_string_literal: true

require 'csv'
require 'active_support/core_ext/string'
require 'comma_splice/version'
require 'comma_splice/base'
require 'comma_splice/helpers/csv_content_finder'
require 'comma_splice/helpers/csv_variable_column_finder'

require 'comma_splice/comma_corrector'
require 'comma_splice/csv_line_corrector'
require 'comma_splice/csv_line'
require 'comma_splice/reordering_possibilities'
require 'byebug'

module CommaSplice
  class Error < StandardError; end




  def self.correct_file(*args)
    fixer = CommaSplice::Base.new(*args)

    byebug
    puts fixer.corrected_file_contents

  end
end
