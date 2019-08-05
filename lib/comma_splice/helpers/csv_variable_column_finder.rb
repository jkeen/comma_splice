module CommaSplice
  # Given a header line and some value lines this will try to figure out the columns
  # where it's likely an error might be.
  # Columns with all the same length



  class CSVVariableColumnFinder
    attr_reader :start_column, :end_column

    def initialize(header_line, value_lines)
      @values = value_lines
      @header = header_line

      find_variable_column_boundaries
    end

    def find_variable_column_boundaries
      # Now given both of these, we can eliminate some columns on the left and right
      variables = left_to_right_index.zip(right_to_left_index).map do |pair|
        pair == [false, false]
      end

      start_column = variables.find_index(true)
      end_column = variables.reverse.find_index(true) * -1

      @start_column = start_column
      @end_column = end_column
    end

    private

    def left_to_right_index
      left_to_right_index = []
      @header.split(',').size.times do |time|
        left_to_right_index.push(@values.map do |value_line|
          value_line.split(',')[time].size
        end.uniq.size == 1)
      end

      left_to_right_index
    end

    def right_to_left_index
      right_to_left_index = []
      @header.split(',').size.times do |time|
        right_to_left_index.unshift(@values.map do |value_line|
          value_line.split(',')[-time].size
        end.uniq.size == 1)
      end

      right_to_left_index
    end
  end
end
