require 'rakyll'
require './parses.rb'

Rakyll.dsl do
  copy 'assets/*'
  copy 'base_data/images/*/*'

  create 'events.html' do
    @events = []
    apply 'events.html.erb'
    apply 'default.html.erb'
  end
end