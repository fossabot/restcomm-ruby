describe Restcomm::Util::Configuration do
  it 'should have an account sid attribute' do
    config = Restcomm::Util::Configuration.new
    config.account_sid = 'someSid'
    expect(config.account_sid).to eq('someSid')
  end

  it 'should have an auth token attribute' do
    config = Restcomm::Util::Configuration.new
    config.auth_token = 'someToken'
    expect(config.auth_token).to eq('someToken')
  end
end
