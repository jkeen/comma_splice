# frozen_string_literal: true

require 'spec_helper'
describe CommaSplice::ContentFinder do
  context 'with no delimiter specified' do
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
  end

  describe 'specify start and end line' do
    subject do
      file = read_test_csv('find-content.csv')
      CommaSplice::ContentFinder.new(file, 15, -1)
    end

    it 'finds the csv content bounds' do
      expect(subject.start_line).to eq(15)
      expect(subject.end_line).to eq(-1)
    end
  end

  describe 'no header' do
    subject do
      file = read_test_csv('unescaped-commas.csv')
      CommaSplice::ContentFinder.new(file, nil, nil, ',')
    end

    it 'finds the csv content bounds' do
      expect(subject.start_line).to eq(0)
      expect(subject.end_line).to eq(-1)
    end
  end

  context 'with comma as delimiter' do
    describe 'non-csv header' do
      subject do
        file = read_test_csv('unescaped-commas-and-non-csv-header.csv')
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
      file = read_test_csv('equal-columns.csv')
      CommaSplice::ContentFinder.new(file)
    end

    it 'finds the csv content bounds' do
      expect(subject.start_line).to eq(15)
      expect(subject.end_line).to eq(-1)
    end
  end

  context 'with colon as delimiter' do
    describe 'non-csv header' do
      subject do
        file = read_test_csv('unescaped-colons-and-non-csv-header.csv')
        CommaSplice::ContentFinder.new(file, nil, nil, ';')
      end

      it 'finds the csv content bounds' do
        expect(subject.start_line).to eq(15)
        expect(subject.end_line).to eq(-1)
      end
    end

    describe 'no header' do
      subject do
        file = read_test_csv('unescaped-colons.csv')
        CommaSplice::ContentFinder.new(file, nil, nil, ';')
      end

      it 'finds the csv content bounds' do
        expect(subject.start_line).to eq(0)
        expect(subject.end_line).to eq(-1)
      end
    end
  end
end
