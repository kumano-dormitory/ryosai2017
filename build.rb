require 'rakyll'

class Event
  def body
    'some-body'
  end
end

Rakyll.dsl do
  copy 'assets/*'
  copy 'base_data/images/*/*'

  create 'events.html' do
    @events = 10.times.map { Event.new }
    apply 'events.html.erb'
    apply 'default.html.erb'
  end
end