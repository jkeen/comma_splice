module CommaSplice
  class Base
    attr_reader :file_contents, :csv_content, :start_line, :end_line

    def initialize(file_path, start_line: nil, end_line:nil, start_column: nil, end_column: nil)
      @file_path       = file_path
      @file_contents   = File.read(file_path, encoding: 'utf-8')

      content_finder = CSVContentFinder.new(@file_contents, start_line, end_line)
      @csv_content  = content_finder.content
      @start_line   = content_finder.start_line
      @end_line     = content_finder.start_line

      finder = CSVVariableColumnFinder.new(@csv_content[0], @csv_content[1..-1])
      @start_column = finder.start_column
      @end_column = finder.end_column

      raise "empty contents #{file_path}" unless @csv_content.present?
    end

    def parsed
      quote_chars = %w[" | ~ ^ & *]
      begin
        CSV.parse(@csv_content.join('\n'), quote_char: quote_chars.shift, headers: :first_row, liberal_parsing: true)
      rescue CSV::MalformedCSVError
        quote_chars.empty? ? raise : retry
      end
    end

    def header
      @header ||= CSVLine.new(csv_content.first)
    end

    def lines_needing_corrections
      correctors.select(&:needs_correcting?)
    end

    def needs_correcting?
      lines_needing_corrections.size.positive?
    end

    def corrected_file_contents
      @corrected_file_contents ||= [
        @file_contents.lines[0, @start_line],
        corrected_lines,
        @file_contents.lines[@end_line, -1]
      ].flatten
    end

    def save!
      save_to(@file_path)
    end

    def save_to(path)
      File.open(path, 'w+') do |f|
        corrected_file_contents.each_with_index do |line, index|
          if corrected_file_contents.size > index && line # don't add an extra line break at the end
            f.puts line
          end
        end
      end
    end

    def to_json
      parsed.try(:to_json)
    end

    # private

    def correctors
      @correctors ||= csv_content.collect do |line|
        CSVLineCorrector.new(header, CSVLine.new(line), @start_column, @end_column)
      end
    end

    def corrected_lines
      correctors.collect do |corrector|
        if corrector.needs_correcting?
          corrector.corrected
        else
          corrector.original
        end
      end
    end
  end
end
