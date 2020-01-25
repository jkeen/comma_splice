# frozen_string_literal: true

module CommaSplice
  # provide an array of CSV headers and and array of CSV values
  # and this will figure out the best correction and prompt
  # you if it can't find out

  class CommaCalculator
    def initialize(headers, values)
      raise StandardError, "Determining all the possibilities to fit #{values.size} values into the #{headers.size} headers #{headers.inspect} is computationally expensive. Please specify the columns where commas might be." if headers.size > 10 && values.size > 10

      @headers = headers
      @values  = values
    end

    def correction
      if @headers.size == @values.size
        @values
      elsif best_options.size == 1
        best_options.first
      elsif best_options.size > 1
        prompt_for_options(best_options)
      else
        prompt_for_options(all_options)
      end
    end

    def all_options
      join_possibilities.collect do |joins|
        values = @values.dup
        joins.collect do |join_num|
          val = values.shift(join_num)
          if val.empty?
            nil
          elsif val.size == 1
            val.first
          else
            val.join(',')
          end
        end
      end
    end

    def best_options
      all_options.select do |option|
        option.none? do |o|
          o.to_s.starts_with?(' ') || o.to_s.starts_with?('" ')
        end
      end
    end

    def requires_manual_input?
      needs_correcting? && best_options.many?
    end

    def needs_correcting?
      @headers.size < @values.size
    end

    private

    def join_possibilities
      JoinPossibilities.new(@values.size, @headers.size).possibilities
    end

    def prompt_for_options(options)
      longest_header = @headers.max_by(&:length)

      options.each_with_index do |option, index|
        @headers.each_with_index do |header, i|
          marker = i.zero? ? "(#{index + 1})" : ''
          puts marker.ljust(5) +
               header.ljust(longest_header.size) + ': ' +
               option[i]
        end
        puts "\n"
      end

      selected_option = nil
      until selected_option && selected_option.to_i > 0
        puts 'which one is correct?'
        selected_option = STDIN.gets
      end

      options[selected_option.to_i - 1]
    end
  end
end
