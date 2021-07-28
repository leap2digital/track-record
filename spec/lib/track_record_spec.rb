describe TrackRecord do
  it 'returns a proper version' do
    expect(TrackRecord::VERSION).to be_a(String)
  end

  it 'returns 100 as the query amount' do
    ENV['FEED_EVENTS_QUERY_AMOUNT'] = nil
    expect(TrackRecord::QUERY_AMOUNT).to eq(100)
  end

  it 'should not have a nil client' do
    expect(TrackRecord::Client).not_to be_nil
  end
end
