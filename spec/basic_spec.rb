# frozen_string_literal: true

require 'spec_helper'
describe CommaSplice do
  context 'with no separator specified' do
    context 'unescaped-commas-and-non-header' do
      subject do
        CommaSplice::FileCorrector.new(test_file_path('unescaped-commas-and-non-csv-header.csv'))
      end

      it 'should make proper corrections' do
        fixed_contents = read_test_file('unescaped-commas-and-non-csv-header-fixed.csv')
        subject.save('test-file.txt')

        expect(File.read('test-file.txt')).to match(fixed_contents)
      end
    end

    context 'unescaped-commas' do
      subject do
        CommaSplice::FileCorrector.new(test_file_path('unescaped-commas.csv'))
      end

      it 'should make proper corrections' do
        fixed_contents = read_test_file('unescaped-commas-fixed.csv')
        subject.save('test-file.txt')

        expect(File.read('test-file.txt')).to match(fixed_contents)
      end
    end

    context 'unescaped-quotes' do
      subject do
        CommaSplice::FileCorrector.new(test_file_path('unescaped-quotes.csv'))
      end

      it 'should make proper corrections' do
        fixed_contents = read_test_file('unescaped-quotes-fixed.csv')
        subject.save('test-file.txt')

        expect(File.read('test-file.txt')).to match(fixed_contents)
      end
    end

    context 'unknown combo should prompt for option' do
      subject do
        CommaSplice::FileCorrector.new(test_file_path('10000-maniacs.csv'))
      end

      it 'should prompt for correction' do
        # expect($stdin).to receive(:gets).and_return('4')

        fixed_contents = read_test_file('10000-maniacs-fixed.csv')
        subject.save('test-file.txt')
        expect(File.read('test-file.txt')).to match(fixed_contents)
      end
    end
  end

  context 'with comma as separator' do
    context 'unescaped-commas-and-non-header' do
      subject do
        CommaSplice::FileCorrector.new(test_file_path('unescaped-commas-and-non-csv-header.csv'), separator: ',')
      end

      it 'should make proper corrections' do
        fixed_contents = read_test_file('unescaped-commas-and-non-csv-header-fixed.csv')
        subject.save('test-file.txt')

        expect(File.read('test-file.txt')).to match(fixed_contents)
      end
    end

    context 'unescaped-commas' do
      subject do
        CommaSplice::FileCorrector.new(test_file_path('unescaped-commas.csv'), separator: ',')
      end

      it 'should make proper corrections' do
        fixed_contents = read_test_file('unescaped-commas-fixed.csv')
        subject.save('test-file.txt')

        expect(File.read('test-file.txt')).to match(fixed_contents)
      end
    end

    context 'unescaped-quotes' do
      subject do
        CommaSplice::FileCorrector.new(test_file_path('unescaped-quotes.csv'), separator: ',')
      end

      it 'should make proper corrections' do
        fixed_contents = read_test_file('unescaped-quotes-fixed.csv')
        subject.save('test-file.txt')

        expect(File.read('test-file.txt')).to match(fixed_contents)
      end
    end

    context 'unknown combo should prompt for option' do
      subject do
        CommaSplice::FileCorrector.new(test_file_path('10000-maniacs.csv'), separator: ',')
      end

      it 'should prompt for correction' do
        # expect($stdin).to receive(:gets).and_return('4')

        fixed_contents = read_test_file('10000-maniacs-fixed.csv')
        subject.save('test-file.txt')
        expect(File.read('test-file.txt')).to match(fixed_contents)
      end
    end
  end

  context 'with semicolon as separator' do
    context 'unescaped-commas-and-non-header' do
      subject do
        CommaSplice::FileCorrector.new(test_file_path('unescaped-semicolons-and-non-csv-header.csv'), separator: ';')
      end

      it 'should make proper corrections' do
        fixed_contents = read_test_file('unescaped-semicolons-and-non-csv-header-fixed.csv')
        subject.save('test-file.txt')

        expect(File.read('test-file.txt')).to match(fixed_contents)
      end
    end

    context 'unescaped-semicolons' do
      subject do
        CommaSplice::FileCorrector.new(test_file_path('unescaped-semicolons.csv'), separator: ';')
      end

      it 'should make proper corrections' do
        fixed_contents = read_test_file('unescaped-semicolons-fixed.csv')
        subject.save('test-file.txt')

        expect(File.read('test-file.txt')).to match(fixed_contents)
      end
    end

    context 'unescaped-quotes' do
      subject do
        CommaSplice::FileCorrector.new(test_file_path('unescaped-quotes-semicolons.csv'), separator: ';')
      end

      it 'should make proper corrections' do
        fixed_contents = read_test_file('unescaped-quotes-semicolons-fixed.csv')
        subject.save('test-file.txt')

        expect(File.read('test-file.txt')).to match(fixed_contents)
      end
    end

    context 'unknown combo should prompt for option' do
      subject do
        CommaSplice::FileCorrector.new(test_file_path('10000-maniacs-semicolons.csv'), separator: ';')
      end

      it 'should prompt for correction' do
        fixed_contents = read_test_file('10000-maniacs-semicolons-fixed.csv')
        subject.save('test-file.txt')
        expect(File.read('test-file.txt')).to match(fixed_contents)
      end
    end
  end

  context 'unescaped-commas' do
    subject do
      CommaSplice::FileCorrector.new(test_file_path('unescaped-commas.csv'))
    end

    it 'should make proper corrections' do
      fixed_contents = read_test_file('unescaped-commas-fixed.csv')
      subject.save('test-file.txt')

      expect(File.read('test-file.txt')).to match(fixed_contents)
    end
  end

  context 'unescaped-quotes' do
    subject do
      CommaSplice::FileCorrector.new(test_file_path('unescaped-quotes.csv'))
    end

    it 'should make proper corrections' do
      fixed_contents = read_test_file('unescaped-quotes-fixed.csv')
      subject.save('test-file.txt')

      expect(File.read('test-file.txt')).to match(fixed_contents)
    end
  end

  context 'unescaped-quotes-2' do
    subject do
      CommaSplice::FileCorrector.new(test_file_path('unescaped-quotes-2.csv'))
    end

    it 'should make proper corrections' do
      fixed_contents = read_test_file('unescaped-quotes-2-fixed.csv')
      subject.save('test-file.txt')

      expect(File.read('test-file.txt')).to match(fixed_contents)
    end
  end

  context 'equal columns' do
    it 'should throw error' do
      expect do
        CommaSplice::FileCorrector.new(test_file_path('equal-columns.csv')).corrected
      end.to raise_error StandardError
    end

    it 'should not throw error when columns are supplied' do
      expect do
        CommaSplice::FileCorrector.new(test_file_path('equal-columns.csv'), start_column: 4, end_column: -5).corrected
      end.to_not raise_error
    end
  end

  context 'specified content' do
    subject do
      CommaSplice::FileCorrector.new(test_file_path('find-content.csv'), start_line: 15, end_line: -1)
    end

    it 'finds the csv content bounds' do
      fixed_contents = read_test_file('find-content-fixed.csv')
      subject.save('test-file.txt')
      expect(File.read('test-file.txt')).to match(fixed_contents)
    end
  end
end
