# frozen_string_literal: true

require 'spec_helper'
describe CommaSplice::VariableColumnFinder do
  describe 'unescaped-commas' do
    subject do
      file = read_test_csv('unescaped-commas.csv')
      CommaSplice::VariableColumnFinder.new(file.lines[0], file.lines[1..-1])
    end

    it 'should detect correct column bounds' do
      expect(subject.start_column).to eq(4)
      expect(subject.end_column).to eq(-5)
    end
  end

  describe 'with no delimiter specified' do
    subject do
      file = read_test_csv('unescaped-commas.csv')
      CommaSplice::VariableColumnFinder.new(file.lines[0], file.lines[1..-1])
    end

    it 'should detect correct column bounds' do
      expect(subject.start_column).to eq(4)
      expect(subject.end_column).to eq(-5)
    end
  end

  describe 'short content' do
    subject do
      file = read_test_csv('equal-columns.csv')
      CommaSplice::VariableColumnFinder.new(file.lines[15], file.lines[16..-1])
    end

    it 'should detect correct column bounds' do
      expect(subject.start_column).to eq(0)
      expect(subject.end_column).to eq(-1)
    end
  end

  describe 'with comma as delimiter' do
    subject do
      file = read_test_csv('unescaped-commas.csv')
      CommaSplice::VariableColumnFinder.new(file.lines[0], file.lines[1..-1], ',')
    end

    it 'should detect correct column bounds' do
      expect(subject.start_column).to eq(4)
      expect(subject.end_column).to eq(-5)
    end
  end

  describe 'with colon as delimiter' do
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
