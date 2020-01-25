# frozen_string_literal: true

module CommaSplice
  # Given a file this will find the CSV content. Some files have some non-csv junk at the top

  class ContentFinder
    attr_reader :start_line, :end_line, :content

    def initialize(file_contents, start_line = nil, end_line = nil)
      @file_contents = file_contents

      if start_line && end_line
        # the csvs this was built for have non-csv headers
        @start_line  = start_line
        @end_line    = end_line
        @content     = @file_contents.lines[@start_line..@end_line]
      else
        find_content
      end
    end

    def find_content
      @start_line = @file_contents.lines.find_index do |line|
        Line.new(line).values.size > 2
      end

      relative_end_line = @file_contents.lines[@start_line..-1].find_index do |line|
        Line.new(line).values.size < 2
      end

      @end_line = if relative_end_line
                    @start_line + relative_end_line - 1
                  else
                    -1
                  end

      @content = @file_contents.lines[@start_line..@end_line]
    end

    def parsed
      quote_chars = %w[" | ~ ^ & *]
      begin
        CSV.parse(@content.join("\n"), quote_char: quote_chars.shift, headers: :first_row, liberal_parsing: true)
      rescue CSV::MalformedCSVError
        quote_chars.empty? ? raise : retry
      end
    end
  end
end
