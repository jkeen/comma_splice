# frozen_string_literal: true

require 'spec_helper'
describe CommaSplice do
  context 'numbers' do
    subject do
      CommaSplice::FileCorrector.new(test_csv_path('numbers.csv'), start_column: 4, end_column: -5)
    end

    it 'should make proper corrections without needing prompting' do
      fixed_contents = read_test_csv('numbers-fixed.csv')
      subject.save('test-file.txt')

      expect(File.read('test-file.txt')).to eq(fixed_contents)
    end
  end
end
