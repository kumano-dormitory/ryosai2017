require 'rakyll'
require './parses.rb'
require 'uri'

IMAGE_BASE_PATH = 'base_data'
CSV_PATH = './base_data/list.csv'

def all_events
  Event.create_list_from_csv(CSV_PATH).values.reduce(:+)
end

def regulars
  Event.create_list_from_csv(CSV_PATH)[:regulars]
end
def permanents
  Event.create_list_from_csv(CSV_PATH)[:permanents]
end
def guerrillas
  Event.create_list_from_csv(CSV_PATH)[:guerrillas]
end

Rakyll.dsl root_path: 'ryosai2017', watch: ARGV.include?('--watch') do
  copy 'assets/*'
  copy 'base_data/*.jpg'
  minify 'base_data/images/*/*', width: 600, grayscale: true

  ['contact.html', 'access.html', 'contrib.html'].each do |static_html_filename|
    match static_html_filename do
      apply 'default.html.erb'
    end
  end

  create 'index.html', dependencies: [CSV_PATH] do
    @title = '熊野寮祭'
    apply 'index.html.erb'
    apply 'default.html.erb'
  end

  create 'events.html', dependencies: [CSV_PATH] do
    @permanents = permanents
    @regulars = regulars
    @guerrillas = guerrillas
    @title = '企画一覧'
    apply 'events_index.html.erb'
    apply 'default.html.erb'
  end

  create 'guerrilla.html', dependencies: [CSV_PATH] do
    @title = 'ゲリラ企画'
    @events = guerrillas
    apply 'events.html.erb'
    apply 'default.html.erb'    
  end

  create 'permanent.html', dependencies: [CSV_PATH] do
    @title = '常設企画'
    @events = permanents
    apply 'events.html.erb'
    apply 'default.html.erb'    
  end

  regulars.map { |evt| evt.period.date }.uniq.each do |target_date|
    create "#{target_date}.html", dependencies: [CSV_PATH] do
      @title = "#{target_date.strftime('%m/%d')}(#{%w{月 火 水 木 金 土 日}[target_date.wday]})の企画"
      @events = regulars.select { |evt| evt.period.date == target_date }
      apply 'events.html.erb'
      apply 'default.html.erb'
    end
  end
end
