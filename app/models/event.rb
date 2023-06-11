class Event < ApplicationRecord

include Events::Scopable

  def self.availabilities(date_time)

    [{date: 'yo'}]
  end

  private

  def availability(date)
    {date: date, slots: []}
  end
end
