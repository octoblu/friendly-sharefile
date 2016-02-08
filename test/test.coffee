FriendlySharefile = require '../'

describe 'Test', ->
  it 'should boot up and be an instance of sharefile', ->
    @sut = new FriendlySharefile {}
    expect(@sut).to.be.instanceOf FriendlySharefile
