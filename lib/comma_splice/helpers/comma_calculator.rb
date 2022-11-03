# frozen_string_literal: true

module CommaSplice
  # provide an array of CSV headers and and array of CSV values
  # and this will figure out the best correction and prompt
  # you if it can't find out

  class CommaCalculator
    def initialize(headers, values, separator = ',')
      if headers.size > 10 && values.size > 10
        raise StandardError,
              "Determining all the possibilities to fit #{values.size} values into the #{headers.size} headers #{headers.inspect} is computationally expensive. Please specify the columns where commas might be."
      end

      @separator      = separator
      @headers        = headers
      @values         = values
      @longest_header = @headers.max_by(&:length)
    end

    def correction
      if @headers.size == @values.size
        @values
      elsif best_options.size == 1
        best_options.first.option
      elsif best_options.size > 1
        prompt_for_options(best_options)
      else
        prompt_for_options(ranked_options)
      end
    end

    def ranked_options
      @all_options ||= join_possibilities.collect do |joins|
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

      @ranked_options ||= @all_options.collect do |option|
        OptionScorer.new(option, separator: @separator)
      end
    end

    def score_option(option)
      OptionScorer.new(option, separator: @separator).score
    end

    def best_options
      max_score = ranked_options.collect { |o| o.score }.max
      ranked_options.select { |o| o.score == max_score }
    end

    def needs_manual_input?
      !best_options.one?
    end

    def needs_correcting?
      @headers.size < @values.size
    end

    def print_all_options
      ranked_options.each_with_index do |option, index|
        print_option(option, index)
      end
    end

    protected

    def join_possibilities
      JoinPossibilities.new(@values.size, @headers.size).possibilities
    end

    def prompt_for_options(options)
      options.each_with_index do |option, index|
        print_option(option, index)
      end

      puts 'press 0 to see all options' if ranked_options.size != options.size

      selected_option = nil
      until selected_option && selected_option.to_i > -1
        puts 'which one is correct?'
        selected_option = STDIN.gets
      end

      if selected_option.to_i == 0
        prompt_for_options(ranked_options.sort_by { |s| s.score.to_i }.reverse)
      else
        options[selected_option.to_i - 1].option
      end
    end

    def print_option(option, index = nil)
      score_breakdown = option.breakdown

      lines = []
      @headers.each_with_index do |header, i|
        marker = if i.zero? && index
                   "(#{index + 1})"
                 else
                   ''
                 end

        line = marker.ljust(7) +
               header.ljust(@longest_header.size) + ': ' +
               option.option[i].to_s.ljust(75)

        line = line + '| ' + (score_breakdown.shift || '') if CommaSplice.debug

        lines << line
      end
      lines << "\n"
      puts lines.join("\n")
    end
  end
end
