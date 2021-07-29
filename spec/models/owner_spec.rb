# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Owner, type: :model do
  before(:all) do
    @owner = described_class.create(name: 'test_owner')
  end

  after(:all) do
    described_class.all.each do |e|
      e.destroy
    end
  end
  
  it 'has a name' do
    owner = described_class.first
    expect(owner.name).to eq(@owner.name)
  end
end
