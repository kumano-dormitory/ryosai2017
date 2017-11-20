require 'csv'

class Event
  attr_reader :type, :title, :place, :period, :description, :picture_path

  def self.create_list_from_csv(csv_filename)
    events = CSV.read(csv_filename, headers: true, encoding: 'BOM|UTF-8').map(&:to_h).map do |row|
      period = Period.create_from_day_and_time(row['start_day']&.strip, row['start_at']&.strip, row['end_day']&.strip, row['end_at']&.strip)
      self.new(row['type']&.strip, row['title']&.strip, row['where']&.strip, period, row['detail']&.strip, row['file_path']&.strip)
    end
    {
      regulars: events.select { |event| event.type == 'regular' },
      guerrilla: events.select { |event| event.type == 'guerrilla' },
      permanents: events.select { |event| event.type == 'permanent' }
    }
  end

  def initialize(type, title, place, period, description, picture_path)
    @type = type
    @title = title
    @place = place
    @period = period
    @description = description
    @picture_path = picture_path
  end
end

def combine_day_and_time_str(day_str, time_str)
  if !day_str.nil? && !time_str.nil?
    month = day_str[0..1].to_i
    day = day_str[2..3].to_i
    hour, minute = time_str.split(':').map(&:to_i)
    Time.local(2017, month, day, hour, minute)
  end
end

class Period
  def self.create_from_day_and_time(start_day_str, start_at_str, end_day_str, end_at_str)
    start_at = combine_day_and_time_str(start_day_str, start_at_str)
    end_at = combine_day_and_time_str(end_day_str, end_at_str)
    self.new(start_at, end_at)
  end

  def initialize(start_at, end_at)
    @start_at = start_at
    @end_at = end_at
  end
end