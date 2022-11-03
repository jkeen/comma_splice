module CommaSplice
  class Line
    attr_reader :values, :line, :separator

    def initialize(line, separator)
      @line = line
      @separator = separator
      @values = parse_csv_content(line).first
    end

    private

    def parse_csv_content(content, headers = false)
      quote_chars = %w[" | ~ ^ & *]
      begin
        CSV.parse(content.mb_chars.tidy_bytes.to_s, col_sep: @separator, quote_char: quote_chars.shift,
                                                    headers:, liberal_parsing: true)
      rescue CSV::MalformedCSVError
        quote_chars.empty? ? raise : retry
      end
    end
  end
end
