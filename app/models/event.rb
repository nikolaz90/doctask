class Event < ApplicationRecord

include Events::Scopable

  def self.availabilities(date_time)
    p openings
  end

  private

  def open_slots
    (starts_at.strftime("%H:%M")..ends_at.strftime("%H:%M"))
  end

  def self.availability(date)
    {date: date, slots: []}
  end
end
