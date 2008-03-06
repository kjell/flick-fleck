module Flick
  class PhotoProxy
    def initialize
      @f = Flick.fleck
    end

    def find(*args)
      options = args.extract_options!

      case args.first
        when :first then find_initial(options)
        when :all   then find_every(options)
        #else             find_from_ids(args, options)
      end
    end

    def find_initial(options)
      options.update(:per_page => 1)
      find_every(options).first
    end

    def find_every(options)
      query = options.delete(:where)
      prepare_query(query)

      doc = @f._photos.search!(query)
      Flick::Helpers.photos_from_xml(doc/:photo)
    end

    def prepare_query(query)
      if query[:user] and query[:user] !~ /\d{12}@.{3}/
        query.merge!(:user_id => @f.people.find(query.delete(:user)).nsid)
      end
    end
  end

  Photo = Struct.new(:id, :title, :owner_id, :url, :description, :comments, :tags) do
    def owner
      Flick.fleck.people.find(owner_id)
    end
    
    %w[url description comments tags].each do |field|
      define_method(field) do
        var = instance_variable_get("@#{field}".to_sym)
        var ? var : get_info.send(field)
      end
    end
    
    def sizes
      (Flick.fleck._photos.getSizes!(:photo_id => id)/:size).inject({}) do |sizes, size|
        sizes[size['label'].downcase] = size.raw_attributes
        sizes
      end.with_indifferent_access
    end
    
    private
    
    def get_info
      doc = Flick.fleck._photos.getInfo!(:photo_id => id)
      @info = Hash.from_flickr_response(doc)[:photo]
      
      %w[url description comments].each do |field|
        instance_variable_set("@#{field}".to_sym, doc.at(field).inner_html)
      end
      
      @tags = (doc.at(:tags)/:tag).map(&:inner_html)
            
      self
    end
  end
end