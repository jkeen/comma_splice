module CommaSplice
  # scores options based on how likely they are to be correct
  class OptionScorer
    attr_reader :option

    def initialize(option)
      @option = option
      @start_score = 100
    end

    def breakdown
      score     = @start_score
      breakdown = []

      rules.each do |rule|
        rule_score = send(rule.to_sym)
        score += rule_score
        if rule_score != 0
          breakdown << "#{rule_score.to_s.ljust(3)} #{rule.to_sym}"
        end
      end

      breakdown.unshift("score: #{score}")
    end

    def score
      score = @start_score
      rules.each do |rule|
        score += send(rule.to_sym)
      end
      score
    end

    def options_that_start_with_a_space
      option.select do |o|
        o.to_s.starts_with?(' ')
      end.size * -10
    end

    def options_that_start_with_a_quote_followed_by_a_space
      option.select do |o|
        o.to_s.starts_with?('" ')
      end.size * -1
    end

    def options_that_start_with_a_comma
      option.select do |o|
        o.to_s.starts_with?(',')
      end.size * -5
    end

    def options_that_end_with_a_comma
      option.select do |o|
        o.to_s.ends_with?(',')
      end.size * -5
    end

    def options_that_have_words_joined_by_commas
      option.select do |o|
        o.to_s.match(/[^0-9\s],[\w]/) || o.to_s.match(/[\w],[^0-9\s]/)
      end.compact.size * -5
    end

    def options_that_are_blank
      option.select do |o|
        o.to_s.strip.blank?
      end.size * -5
    end

    def options_that_have_longest_comma_separated_number
      # favor items that have a longer comma separated number
      # i.e in the following example, option 1 should win
      # (1)    artist    : Half Japanese
      #        title     : 1,000,000,000 Kisses
      #        albumtitle: Beautiful Songs: The Best of Jad Fair & Half Japanese
      #        label     : Stillwater/Fire
      #
      #
      # (2)    artist    : Half Japanese,1,000,000
      #        title     : 000 Kisses
      #        albumtitle: Beautiful Songs: The Best of Jad Fair & Half Japanese
      #        label     : Stillwater/Fire
      #
      #
      # (3)    artist    : Half Japanese,1
      #        title     : 000,000,000 Kisses
      #        albumtitle: Beautiful Songs: The Best of Jad Fair & Half Japanese
      #        label     : Stillwater/Fire
      #
      #
      # (4)    artist    : Half Japanese,1,000
      #        title     : 000,000 Kisses
      #        albumtitle: Beautiful Songs: The Best of Jad Fair & Half Japanese
      #        label     : Stillwater/Fire

      option.collect do |o|
        result = o.to_s.scan(/\d{1,3}(?:,\d{1,3})*(?:\.\d+)?/)
        if result.size.positive? && result.first.index(',')
          result.join(',').size
        else
          0
        end
      end.max.to_i
    end

    private

    def rules
      methods.grep(/options_that/)
    end
  end
end
