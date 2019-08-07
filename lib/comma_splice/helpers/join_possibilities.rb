# frozen_string_literal: true

module CommaSplice
  class JoinPossibilities
    attr_reader :from_size, :to_size

    def initialize(value_count, header_count)
      @from_size = value_count
      @to_size   = header_count
    end

    def possibilities
      @possibilities ||= permutations(combos(from_size, to_size))
    end

    private

    def permutations(combinations)
      # get all permutations of those combinations
      # to determine every possibility of join

      all_permutations = combinations.collect do |combo|
        combo.permutation(to_size).to_a
      end

      # flatten down to a list of arrays
      all_permutations.flatten(1).uniq
    end

    def combos(desired_size, count, minimum = 1)
      # determine all combinations of [count] numbers that add up to [desired_size]
      # e.g if we have an array of 6 items and want an array of 4 items
      # we need 4 numbers that add up to 6, => [[1, 1, 1, 3], [1, 1, 2, 2]]

      return [] if desired_size < count || desired_size < minimum
      return [desired_size] if count == 1

      (minimum..desired_size - 1).flat_map do |i|
        combos(desired_size - i, count - 1, i).map { |r| [i, *r] }
      end
    end
  end
end
