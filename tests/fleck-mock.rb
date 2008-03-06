module Flick
  class Fleck
    def mock!() FlickFleckMock.new(@key); end
  end
end

class FlickFleckMock < Flick::Fleck # Lets hijack the call and give back a pre-saved xml file.
  def make_call_to_flickr_with_mock(api_url)
    method = "#{api_url}&".match(/method=flickr\.([a-z|A-Z|\.]*)/) # append a & to the end of the url to make the regex easy
    #return Hpricot.XML(open("fragments/#{method[1]}.xml")) # fragments/ saves flickr's responses to save the constant back and forth
    if method[1]
      Hpricot.XML(open("fragments/#{method[1]}.xml"))
    else
      puts "no matching fragments saved, calling out to flickr"
      make_call_to_flickr_without_mock(api_url)
    end
  end
  
  alias_method_chain :make_call_to_flickr, :mock
end