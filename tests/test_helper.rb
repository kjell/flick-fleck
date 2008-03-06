$: << File.dirname(__FILE__) + '/../lib/'
%w[rubygems test/spec flick/fleck fleck-mock].each {|lib| require lib}