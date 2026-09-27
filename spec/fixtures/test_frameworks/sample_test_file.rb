# frozen_string_literal: true

describe 'Word' do
  it 'shouts' do
    expect('pdx'.upcase).to eq('PDX')
  end

  it 'counts' do
    expect('pdx'.length).to eq(3)
  end
end
