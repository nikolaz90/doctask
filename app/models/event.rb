class Event < ApplicationRecord
  include Events::Scopable

  def self.availabilities(date_time)
    p openings.map(&:availability)
  end

  def self.slots(starts_at, ends_at)
    number_of_half_hours = ((ends_at - starts_at) / 1.hour).floor * 2
    number_of_half_hours.times.map { |i| starts_at + i * 30.minutes }
  end

  def booked_slots
    return 'this is an opening' if kind == 'opening'

    slots_show_time
  end

  def open_slots
    return 'this is an appointment' if kind == 'appointment'

    slots = Event.slots(starts_at, ends_at)
    bookings = Event.appointments_today(starts_at).map(&:booked_slots).flatten
    slots.reject! { |date_time| bookings.include?(date_time.strftime('%H:%M')) }

    slots.map { |date_time| date_time.strftime('%H:%M') }
  end

  def availability
    return 'this is an appointment' if kind == 'appointment'

    { date: starts_at.to_date, slots: open_slots }
  end

  def self.round_down(starts_at)
    Time.at((starts_at.to_f / 30.minutes).round * 30.minutes)
  end

  private

  def slots_show_time
    slots = Event.slots(starts_at, ends_at)
    slots.map { |date_time| date_time.strftime('%H:%M') }
  end
end
