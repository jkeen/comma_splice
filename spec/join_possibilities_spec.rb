# frozen_string_literal: true

require 'spec_helper'
describe CommaSplice::JoinPossibilities do
  subject do
    CommaSplice::JoinPossibilities
  end

  it 'correctly calculates the possibilities going from 5 to 3' do
    expect(subject.new(5, 3).possibilities).to eq([[1, 1, 3], [1, 3, 1], [3, 1, 1], [1, 2, 2], [2, 1, 2], [2, 2, 1]])
  end

  it 'correctly calculates the possibilities going from 4 to 3' do
    expect(subject.new(4, 3).possibilities).to eq([[1, 1, 2], [1, 2, 1], [2, 1, 1]])
  end

  it 'correctly calculates the possibilities going from 7 to 5' do
    expect(subject.new(7, 5).possibilities).to eq([[1, 1, 1, 1, 3], [1, 1, 1, 3, 1], [1, 1, 3, 1, 1], [1, 3, 1, 1, 1], [3, 1, 1, 1, 1], [1, 1, 1, 2, 2], [1, 1, 2, 1, 2], [1, 1, 2, 2, 1], [1, 2, 1, 1, 2], [1, 2, 1, 2, 1], [1, 2, 2, 1, 1], [2, 1, 1, 1, 2], [2, 1, 1, 2, 1], [2, 1, 2, 1, 1], [2, 2, 1, 1, 1]])
  end
end
