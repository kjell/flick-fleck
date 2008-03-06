module Flick
  class PersonProxy
    def find(identifier)
      email, nsid, name = /(.*)@(.*)\.(.*)/, /(\d+)@N../, /.*/
      method, key = case identifier
        when email then [:findByEmail!, :find_email]
        when nsid  then [:getInfo!, :user_id]
        when name  then [:findByUsername!, :username]
      end
      doc = Flick.fleck._people.send(method, {key => identifier})
      
      nsid = doc.at(:user) ? doc.at(:user)['nsid'] : doc.at(:person)['nsid']
      Person.new(nsid, doc.at(:username).inner_html)
    end
  end

  Person = Struct.new(:nsid, :username, :client, :url) do
    def favorites(options={})
      doc = Flick.fleck.favorites.getPublicList!(options.merge(:user_id => nsid))
      Flick::Helpers.photos_from_xml(doc/:photo)
    end
    
    def url
      @url ? @url : get_info.url
    end
    
    private
    
    def get_info
      doc = Flick.fleck._people.getInfo!(:user_id => nsid)
      @info = Hash.from_flickr_response(doc)[:person]
      
      @url = @info[:photosurl]
            
      self
    end
  end
end