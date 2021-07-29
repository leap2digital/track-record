# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Owner, type: :model do
  before(:all) do
    @owner = described_class.create(name: 'test_owner')
  end
  
  it 'has a name' do
    owner = described_class.last
    expect(owner.name).to eq(@owner.name)
  end

  it 'has a store' do
    @owner.stores.create(name: 'test_store')
    expect(@owner.stores.last).to_not be_nil
  end

  it 'records creation in elasticsearch' do
    Elasticsearch::Model.client.indices.refresh(index: @owner.audit_index_name)
    expect(@owner.feed['Owner'].last['event_action']).to eq('create')
    expect(@owner.feed['Owner'].last['changes']['name']).to eq([nil, 'test_owner'])
  end

  it 'records update in elasticsearch' do
    @owner.update(name: 'new_test_owner')
    Elasticsearch::Model.client.indices.refresh(index: @owner.audit_index_name)
    expect(@owner.feed['Owner'].last['event_action']).to eq('update')
    expect(@owner.feed['Owner'].last['changes']['name']).to eq(['test_owner', 'new_test_owner'])
  end
end
