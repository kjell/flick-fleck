require 'test_helper'

describe 'a FlickFleck client' do
  before do
    @ff = Flick::Fleck.new('99e25a0747970e8e909245b826904d74').mock!
  end
  
  it 'should test echo' do
    echo = @ff.test.echo!(:test => 'testing 123')
    echo.should.be.an.instance_of(Hpricot::Doc)
    (echo/:method).inner_html.should.equal 'flickr.test.echo'
    (echo/:test).inner_html.should.equal 'testing 123' # test that we're passing our query string correctly
    echo.at(:rsp)['stat'].should.equal 'ok'
  end
  
  it 'should pass things on to proxy objects' do
    @ff.photos.should.be.an.instance_of(Flick::PhotoProxy)
    @ff.people.should.be.an.instance_of(Flick::PersonProxy)
  end
  
  xit 'should implement the authentication protocols' do
    
  end
end