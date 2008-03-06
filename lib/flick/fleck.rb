%w[rubygems open-uri hpricot activesupport erb ruby-debug].each {|lib| require lib}

$: << File.dirname(__FILE__)
require 'fleck/extensions'
require 'fleck/base'
require 'fleck/people'
require 'fleck/photos'
