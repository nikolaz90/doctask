class Event < ApplicationRecord
  include Events::Scopable

  def self.availabilities(date_time)
    p openings
  end

  def open_slots
    number_of_half_hours = ((ends_at - starts_at) / 1.hour).floor * 2
    number_of_half_hours.times.map { |i| starts_at + i * 30.minutes }
  end

  def slots_show_time(slots = open_slots)
    slots.map { |date_time| date_time.strftime('%H:%M') }
  end

  def availability
    { date: starts_at.strftime('%d/%m/%Y'), slots: slots_show_time }
  end
end
