module CommaSplice
  class LineCorrector
    attr_reader :headers, :values, :header_line, :value_line, :right_bounds, :left_bounds, :separator

    def initialize(header_line, value_line, left_bounds = 0, right_bounds = -1, separator = ',')
      header_line = Line.new(header_line, separator) unless header_line.is_a?(Line)
      value_line  = Line.new(value_line, separator) unless value_line.is_a?(Line)

      @header_line = header_line
      @value_line = value_line
      @headers = header_line.values
      @values = value_line.values
      @left_bounds = left_bounds
      @right_bounds = right_bounds
      @separator = separator

      raise 'right bounds must be negative' unless right_bounds.negative?
      raise 'left bounds must be not be negative' if left_bounds.negative?
    end

    def needs_correcting?
      @values&.size&.positive? && @headers.size != @values.size
    end

    def needs_manual_input?
      corrector.needs_manual_input?
    end

    def option_count
      corrector.best_options.size
    end

    def all_options
      corrector.ranked_options
    end

    def original
      generate_csv_line(@values)
    end

    def corrected
      # you want to provide this with the smallest set of possibilities
      # for performance reasons. Left and right bounds limit the values
      # where the comma error could be

      # For instance, with the following headers:
      # [playid,playtype,genre,timestamp,artist,title,albumtitle,label,prepost,programtype,iswebcast,isrequest]
      # the only values that could contain an extra comma are "artist,title,albumtitle,label"
      # therefore our left_bounds = 4, right_bounds = -5

      values_before = values[0...left_bounds]
      values_after = values.slice(right_bounds + 1, -(right_bounds + 1))
      generate_csv_line([values_before, corrector.correction, values_after].flatten)
    end

    def print_all_options
      corrector.print_all_options
    end

    protected

    def corrector
      CommaCalculator.new(selected_headers, selected_values, @separator)
    end

    def generate_csv_line(values)
      CSV.generate_line(values, col_sep: @separator)
    end

    def selected_headers
      headers[left_bounds..right_bounds]
    end

    def selected_values
      values[left_bounds..right_bounds]
    end
  end
end
