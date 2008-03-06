#!/usr/bin/env ruby
$: << File.dirname(__FILE__) + '/../lib/'
require 'flick/fleck'

# We run through 11 of my favorites, get their owners, then 
# 11 of their favorites. This takes a while, but generally gives
# photos that are excellent.

Flick.settings.merge!(:per_page => ARGV[0] || 11)

owners = Flick.fleck.people.find('kjell').favorites.map(&:owner)
# I don't know why, but every once in a while it'll come up with a nil photo, hence the reject
faves = owners.map(&:favorites).flatten.reject{|f| f.nil? || f.id.empty?}.sort_by(&:id)

output = faves.inject('') do |out, fave|
  out << <<-snippet
    <li><a href="#{fave.url}"><img src="#{fave.sizes[:medium][:source]}"/></a>
    <p><a href="#{fave.owner.url}">#{fave.owner.username}</a></p></li>
  snippet
end

# name the file acording to the date and time, and keep it around somewhere?
File.open('favorites_squared.html', 'w') {|f| f.write("<ul>#{output}</ul>")}
`open ./favorites_squared.html`