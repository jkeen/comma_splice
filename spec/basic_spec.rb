# frozen_string_literal: true

require 'spec_helper'
describe CommaSplice do
  context 'unescaped-commas-and-non-header' do
    subject do
      CommaSplice::FileCorrector.new(test_csv_path('unescaped-commas-and-non-csv-header.csv'))
    end

    it 'should make proper corrections' do
      fixed_contents = read_test_csv('unescaped-commas-and-non-csv-header-fixed.csv')
      subject.save('test-file.txt')

      expect(File.read('test-file.txt')).to eq(fixed_contents)
    end
  end

  context 'unescaped-commas' do
    subject do
      CommaSplice::FileCorrector.new(test_csv_path('unescaped-commas.csv'))
    end

    it 'should make proper corrections' do
      fixed_contents = read_test_csv('unescaped-commas-fixed.csv')
      subject.save('test-file.txt')

      expect(File.read('test-file.txt')).to eq(fixed_contents)
    end
  end

  context 'unescaped-quotes' do
    subject do
      CommaSplice::FileCorrector.new(test_csv_path('unescaped-quotes.csv'))
    end

    it 'should make proper corrections' do
      fixed_contents = read_test_csv('unescaped-quotes-fixed.csv')
      subject.save('test-file.txt')

      expect(File.read('test-file.txt')).to eq(fixed_contents)
    end
  end

  context 'unknown combo should prompt for option' do
    subject do
      CommaSplice::FileCorrector.new(test_csv_path('10000-maniacs.csv'))
    end

    it 'should prompt for correction' do
      expect($stdin).to receive(:gets).and_return('4')

      fixed_contents = read_test_csv('10000-maniacs-fixed.csv')
      subject.save('test-file.txt')
      expect(File.read('test-file.txt')).to eq(fixed_contents)
    end
  end
end
