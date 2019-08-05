module CommaSplice
  class CSVLineCorrector
    attr_reader :headers, :values, :header_line, :value_line, :right_bounds, :left_bounds

    def initialize(header_line, value_line, left_bounds = 0, right_bounds = -1)
      @header_line = header_line
      @value_line = value_line
      @headers = header_line.values
      @values = value_line.values
      @left_bounds = left_bounds
      @right_bounds = right_bounds

      raise 'right bounds must be less than -1' unless right_bounds < 0
      raise 'left bounds must be greater than zero' unless left_bounds >= 0
    end

    def needs_correcting?
      @values && @values.size > 0 && @headers.size != @values.size
    end

    def original
      @values.join(',')
    end

    def corrected
      # you want to provide this with the smallest set of possibilities
      # for performance reasons. Left and right bounds limit the values
      # where the comma error could be

      # For instance, with the following headers:
      # [playid,playtype,genre,timestamp,artist,title,albumtitle,label,prepost,programtype,iswebcast,isrequest]
      # the only values that could contain an extra comma are "artist,title,albumtitle,label"
      # therefore our left_bounds = 4, right_bounds = -5

      values_before = if left_bounds > 0
                        values[0..(left_bounds - 1)]
                      else
                        []
                      end
                      
      values_after =  if right_bounds < -1
                        values[(right_bounds + 1)..-1]
                      else
                        []
                      end
      [values_before, corrector.correction, values_after].flatten.join(',')
    end

    private

    def corrector
      CommaCorrector.new(selected_headers, selected_values)
    end

    def selected_headers
      headers[left_bounds..right_bounds]
    end

    def selected_values
      values[left_bounds..right_bounds]
    end
  end
end
