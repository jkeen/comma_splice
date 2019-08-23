# frozen_string_literal: true

require 'spec_helper'
describe CommaSplice::VariableColumnFinder do
  context 'with no delimiter specified' do
    subject do
      file = read_test_csv('unescaped-commas.csv')
      CommaSplice::VariableColumnFinder.new(file.lines[0], file.lines[1..-1])
    end

    it 'should detect correct column bounds' do
      expect(subject.start_column).to eq(4)
      expect(subject.end_column).to eq(-5)
    end
  end

  context 'with comma as delimiter' do
    subject do
      file = read_test_csv('unescaped-commas.csv')
      CommaSplice::VariableColumnFinder.new(file.lines[0], file.lines[1..-1], ',')
    end

    it 'should detect correct column bounds' do
      expect(subject.start_column).to eq(4)
      expect(subject.end_column).to eq(-5)
    end
  end

  context 'with colon as delimiter' do
    subject do
      file = read_test_csv('unescaped-colons.csv')
      CommaSplice::VariableColumnFinder.new(file.lines[0], file.lines[1..-1], ';')
    end

    it 'should detect correct column bounds' do
      expect(subject.start_column).to eq(4)
      expect(subject.end_column).to eq(-5)
    end
  end
end
