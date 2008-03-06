class Hash
  # Turn the keys and values from a hash into the parameters of a query string
  def parametrize
    self.inject('') do |string, (k, v)|
      string << "#{k}=#{ERB::Util.url_encode(v)}&"  
    end[0..-2]
  end
end

class Hash
  # Turn an xml document from flickr into a hash.
  def self.from_flickr_response(doc)
    doc = Hpricot.XML(doc) unless doc.respond_to?(:doc?)
    stuff = doc.containers.first.containers
  
    from_hpricot_elements(stuff)
  end
  
  # Here more specifically, turn a collection of Hpricot elements into a Hash.
  #   <urls>
  #	    <url type="photopage">http://www.flickr.com/photos/bees/2733/</url> 
  #   </urls>
  # turns into
  #   {"url"=> {"type"=>"photopage", "value"=>"http://www.flickr.com/photos/bees/2733/"}}
  def self.from_hpricot_elements(stuff)
    stuff.inject({}.with_indifferent_access) do |hash, elem|
      value = if elem.inner_text == elem.inner_html  
        if !elem.raw_attributes.empty?
          {:value => elem.inner_html}.merge(elem.raw_attributes)
        else
          elem.inner_html
        end
      else                                      
        from_hpricot_elements(elem.containers)
      end                                       
  
      hash[elem.name] = value
      hash
    end
  end
end

module Flick
  module Helpers
    module_function
    # TODO: work Hash.from_flickr_response into this to set fields better,
    # rework ::Person and ::Photo to be more flexible.
    def photos_from_xml(photos_xml)
      photos_xml.inject([]) do |photos, photo|
        attributes = %w[id title owner].map{|f| photo[f]}
        photos << Photo.new(*attributes) unless attributes[0].nil?
      end
    end
  end
end

module Flick
  FlickrThing = Struct.new(:test) do
    def extract_simple_info(info)
      instance_variable_set("@#{info}".to_sym, doc.at(info.to_sym).inner_html)
    end
  end
end