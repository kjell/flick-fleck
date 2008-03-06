require 'test_helper'

describe 'the Person interface' do
  before do
    @ff = Flick::Fleck.new('99e25a0747970e8e909245b826904d74').mock!
  end
  
  it 'should let you find users by name, email, or nsid' do
    %w[kjell kjell@station11.net 41894185893@N01].each do |user_handle|
      user = @ff.people.find(user_handle)
      user.should.be.an.instance_of(Flick::Person)
      user.nsid.should.equal '41894185893@N01'
      user.username.should.equal 'kjell'
    end
  end
  
  it 'should grab more info when needed' do
    person = @ff.people.find('kjell')
    person.username.should.equal 'kjell'
    person.url.should.equal 'http://www.flickr.com/photos/kjell/'
  end
  
  it 'should let you find a person\'s favorite photos' do
    favorites = @ff.people.find('kjell').favorites
    favorites.size.should.equal 11
    favorite = favorites.first
    favorite.should.be.an.instance_of(Flick::Photo)
  end
end