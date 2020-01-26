# frozen_string_literal: true

require 'spec_helper'
describe CommaSplice do
  context 'edge cases' do
    subject do
      CommaSplice::FileCorrector.new(test_csv_path('unknowns.csv'))
    end
    it 'should make proper corrections' do
      expect($stdin).to receive(:gets).and_return('2')
      expect($stdin).to receive(:gets).and_return('2')
      expect($stdin).to receive(:gets).and_return('3')

      fixed_contents = read_test_csv('unknowns-fixed.csv')
      subject.save('test-file.txt')

      expect(File.read('test-file.txt')).to eq(fixed_contents)
    end
  end
end
