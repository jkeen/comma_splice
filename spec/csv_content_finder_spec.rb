# frozen_string_literal: true

require 'spec_helper'
describe CommaSplice::CSVContentFinder do
  describe 'non-csv header' do
    subject do
      file = read_test_csv('unescaped-commas-and-non-csv-header.csv')
      CommaSplice::CSVContentFinder.new(file)
    end

    it 'finds the csv content bounds' do
      expect(subject.start_line).to eq(15)
      expect(subject.end_line).to eq(-1)
    end
  end

  describe 'no header' do
    subject do
      file = read_test_csv('unescaped-commas.csv')
      CommaSplice::CSVContentFinder.new(file)
    end

    it 'finds the csv content bounds' do
      expect(subject.start_line).to eq(0)
      expect(subject.end_line).to eq(-1)
    end
  end

end
