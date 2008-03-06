require 'test_helper'

describe 'parsing a flickr response into a Hash' do  
  it 'should work...' do
    expected_hash = HashWithIndifferentAccess.new(:url=> {:type => "photopage", :value => "http://www.flickr.com/photos/bees/2733/"})
    Hash.from_flickr_response(%[<urls>
  	   <url type="photopage">http://www.flickr.com/photos/bees/2733/</url> 
  	</urls>]).should.equal(expected_hash)
  end
end