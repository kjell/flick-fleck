require 'test_helper'

describe 'the Photos interface' do
  before do
    @ff = Flick::Fleck.new('99e25a0747970e8e909245b826904d74').mock!
  end
  
  it 'should let you find photos' do
    photos = @ff.photos.find(:all, :where => {:user => 'kjell', :per_page => 3})
    photos.should.be.an.instance_of(Array)
    photos.size.should.equal 3
    photo = photos.first
    photo.should.be.an.instance_of(Flick::Photo)
    
    photo = @ff.photos.find(:first, :where => {:text => 'P1030965', :user => 'kjell'})
    photo.title.should.equal 'P1030965'
    photo.url.should.equal 'http://www.flickr.com/photos/kjell/2208286194/' 
    photo.description.should.equal '' # a bad testing example, but there isn't a description
    photo.comments.should.equal '2'
    photo.tags.should.equal ["piano", "fingers", "dusk", "blue", "me", "bach"]
  end
  
  it 'should give you the sizes and links to photos' do
    photo = @ff.photos.find(:first, :where => {:user => 'kjell'})
    photo.sizes.should.be.an.instance_of(HashWithIndifferentAccess)
    %w(square thumbnail small medium original).each do |size|
      size = photo.sizes[size]
      size.should.be.an.instance_of(HashWithIndifferentAccess)

      size[:source].should.match /^http:\/\//
      size[:url].should.match /^http:\/\//
    end
  end
  
  it 'should give you the owner as an object' do
    photo = @ff.photos.find(:first, :where => {:text => 'P1030965', :user => 'kjell'})
    photo.owner.should.be.an.instance_of Flick::Person
  end
end