# frozen_string_literal: true

require 'spec_helper'
describe CommaSplice::ContentFinder do
  context 'with no separator specified' do
    describe 'non-csv header' do
      subject do
        file = read_test_file('unescaped-commas-and-non-csv-header.csv')
        CommaSplice::ContentFinder.new(file)
      end

      it 'finds the csv content bounds' do
        expect(subject.start_line).to eq(15)
        expect(subject.end_line).to eq(-1)
      end
    end

    describe 'no header' do
      subject do
        file = read_test_file('unescaped-commas.csv')
        CommaSplice::ContentFinder.new(file)
      end

      it 'finds the csv content bounds' do
        expect(subject.start_line).to eq(0)
        expect(subject.end_line).to eq(-1)
      end
    end
  end

  context 'with comma as separator' do
    describe 'specify start and end line' do
      subject do
        file = read_test_file('find-content.csv')
        CommaSplice::ContentFinder.new(file, 15, -1)
      end

      it 'finds the csv content bounds' do
        expect(subject.start_line).to eq(15)
        expect(subject.end_line).to eq(-1)
      end
    end

    describe 'no header' do
      subject do
        file = read_test_file('unescaped-commas.csv')
        CommaSplice::ContentFinder.new(file, nil, nil, ',')
      end

      it 'finds the csv content bounds' do
        expect(subject.start_line).to eq(0)
        expect(subject.end_line).to eq(-1)
      end
    end

    describe 'non-csv header' do
      subject do
        file = read_test_file('unescaped-commas-and-non-csv-header.csv')
        CommaSplice::ContentFinder.new(file, nil, nil, ',')
      end

      it 'finds the csv content bounds' do
        expect(subject.start_line).to eq(15)
        expect(subject.end_line).to eq(-1)
      end
    end
  end

  describe 'short content' do
    subject do
      file = read_test_file('equal-columns.csv')
      CommaSplice::ContentFinder.new(file)
    end

    it 'finds the csv content bounds' do
      expect(subject.start_line).to eq(15)
      expect(subject.end_line).to eq(-1)
    end
  end

  context 'with semicolon as separator' do
    describe 'non-csv header' do
      subject do
        file = read_test_file('unescaped-semicolons-and-non-csv-header.csv')
        CommaSplice::ContentFinder.new(file, nil, nil, ';')
      end

      it 'finds the csv content bounds' do
        expect(subject.start_line).to eq(15)
        expect(subject.end_line).to eq(-1)
      end
    end

    describe 'no header' do
      subject do
        file = read_test_file('unescaped-semicolons.csv')
        CommaSplice::ContentFinder.new(file, nil, nil, ';')
      end

      it 'finds the csv content bounds' do
        expect(subject.start_line).to eq(0)
        expect(subject.end_line).to eq(-1)
      end
    end
  end
end
