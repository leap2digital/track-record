# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Store, type: :model do
  before(:all) do
    @owner = Owner.create(name: 'test_owner')
    @store = @owner.stores.create(name: 'test_store')
  end

  it 'has an owner' do
    expect(@store.owner).to_not be_nil
  end

  it 'records creation in elasticsearch' do
    Elasticsearch::Model.client.indices.refresh(index: @store.audit_index_name)
    expect(@store.feed['Store'].last['event_action']).to eq('create')
    expect(@store.feed['Store'].last['changes']['name']).to eq([nil, 'test_store'])
  end

  it 'records update in elasticsearch' do
    @store.update(name: 'new_test_store')
    Elasticsearch::Model.client.indices.refresh(index: @store.audit_index_name)
    expect(@store.feed['Store'].last['event_action']).to eq('update')
    expect(@store.feed['Store'].last['changes']['name']).to eq(['test_store', 'new_test_store'])
  end

  it 'records deletion in elasticsearch' do
    index_name = @store.audit_index_name
    @store.destroy
    Elasticsearch::Model.client.indices.refresh(index: index_name)
    Elasticsearch::Model.client.indices.refresh(index: @owner.audit_index_name)
    puts @owner.feed
    expect(@owner.feed['Store'].last['event_action']).to eq('delete')
  end
end
