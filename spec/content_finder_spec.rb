# frozen_string_literal: true

require 'spec_helper'
describe CommaSplice::ContentFinder do
  describe 'non-csv header' do
    subject do
      file = read_test_csv('unescaped-commas-and-non-csv-header.csv')
      CommaSplice::ContentFinder.new(file)
    end

    it 'finds the csv content bounds' do
      expect(subject.start_line).to eq(15)
      expect(subject.end_line).to eq(-1)
    end
  end

  describe 'no header' do
    subject do
      file = read_test_csv('unescaped-commas.csv')
      CommaSplice::ContentFinder.new(file)
    end

    it 'finds the csv content bounds' do
      expect(subject.start_line).to eq(0)
      expect(subject.end_line).to eq(-1)
    end
  end

  describe 'short content' do
    subject do
      file = read_test_csv('equal-columns.csv')
      CommaSplice::ContentFinder.new(file)
    end

    it 'finds the csv content bounds' do
      expect(subject.start_line).to eq(15)
      expect(subject.end_line).to eq(-1)
    end
  end

end
