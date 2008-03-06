module Flick
  include Helpers
  def fleck() @ff ||= Fleck.new('99e25a0747970e8e909245b826904d74'); end
  def settings() @settings ||= {:per_page => 11}; end # this might be bad because it makes it easy to modify the settings on a module-wide basis, but then it might be good too.
  module_function :fleck, :settings
  
  class Fleck
    attr_reader :calls

    def initialize(key)
      @key = key
      @chain, @calls = [], []
    end

    def photos; @photos ||= PhotoProxy.new; end
    def people; @users ||= PersonProxy.new; end

    # I'm using method_missing to pass calls along to flickr, sugared with some rspec-flavor to chain together
    # method calls. So:
    # 
    #   f = Flick::Fleck.new
    #   f.test.echo! will call the test.echo method
    #   f._photos.search!(:tags => 'bach, keyboard') will search for photos tagged as such.
    #
    # Notice the underscore before photos that lets us use the photos method to provide us
    # with a PhotoProxy, which does useful things like find photos. It's the same for #people.
    # Cutesy, sure, but I like it.
    def method_missing(method, *args)
      (@chain << method.to_s.gsub('_', '').to_sym)
      unless method.to_s[-1] == 33 # 33 is the code for '!', 1.9's String#[] will give us the actual character and break this
        self
      else # if the method ends with a bang (!), make the call to flickr
        chain, @chain = @chain, [] # store the call chain as a local variable and then clear it for the next call
        _call(chain.join('.')[0..-2], *args)
      end
    end
    
    private

    def _call(method, *args)
      queries = Flick.settings.merge(args.extract_options!)
      queries.merge!(:api_key => @key, :method => "flickr.#{method}")
      
      make_call_to_flickr("http://api.flickr.com/services/rest/?#{queries.parametrize}")
    end

    def make_call_to_flickr(api_url)
      @calls << api_url # cache [url, response] pairs in the short term?
      doc = Hpricot.XML(open(api_url))
    end
  end
end
