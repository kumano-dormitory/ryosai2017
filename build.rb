require 'rakyll'
require './parses.rb'

IMAGE_BASE_PATH = 'base_data'

all_events = Event.create_list_from_csv('./base_data/list.csv')
regulars = all_events[:regulars]
permanents = all_events[:permanents]
guerrillas = all_events[:guerrillas]
regulars_by_day = regulars.group_by { |regular| regular.period.day_formatted }

Rakyll.dsl do
  copy 'assets/*'
  #minify 'base_data/images/*/*', width: 600, grayscale: true
  copy 'base_data/images/*/*'

  ['index.html', 'contact.html', 'access.html', 'contrib.html'].each do |static_html_filename|
    match static_html_filename do
      apply 'default.html.erb'
    end
  end

  create 'events.html' do
    @title = '企画一覧'
    @regulars_by_day = regulars_by_day
    apply 'events_index.html.erb'
    apply 'default.html.erb'
  end

  create 'guerrilla.html' do
    @title = 'ゲリラ企画'
    @events = guerrillas
    apply 'events.html.erb'
    apply 'default.html.erb'    
  end

  create 'permanent.html' do
    @title = '常設企画'
    @events = permanents
    apply 'events.html.erb'
    apply 'default.html.erb'    
  end

  regulars_by_day.each do |day_formatted, regulars_of_day|
    create "#{day_formatted}.html" do
      @title = "#{day_formatted}の企画"
      @events = regulars_of_day
      apply 'events.html.erb'
      apply 'default.html.erb'
    end
  end
end