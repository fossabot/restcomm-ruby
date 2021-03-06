require 'spec_helper'

describe Restcomm::REST::Message do
  before do
    @message = Restcomm::REST::Message.new('someUri', 'someClient')
  end

  it 'sets up a media resources object' do
    expect(@message).to respond_to(:media)
    expect(@message.media.instance_variable_get('@path')).to eq('someUri/Media')
  end
end
