class Event < ApplicationRecord
  include Events::Scopable

  def self.availabilities(date_time)
    upcoming = upcoming(date_time)

    availability_hashes = 7.times.map { |i| { date: date_time.to_date + i.days, slots: [] } }
    availability_hashes.each do |availability|
      upcoming.each do |event|
        availability[:slots] = event.open_slots(availability[:date]) if event.availability?(availability[:date])
      end
    end
    p availability_hashes
  end

  def self.slots(starts_at, ends_at)
    number_of_half_hours = ((ends_at - starts_at) / 1.hour).floor * 2
    number_of_half_hours.times.map { |i| starts_at + i * 30.minutes }
  end

  def booked_slots
    return 'this is an opening' if kind == 'opening'

    slots_show_time
  end

  def open_slots(availability_date)
    return 'this is an appointment' if kind == 'appointment'

    slots = Event.slots(starts_at, ends_at)
    bookings = Event.appointments_today(availability_date).map(&:booked_slots).flatten

    slots.reject! { |date_time| bookings.include?(date_time.strftime('%H:%M')) }

    slots.map { |date_time| date_time.strftime('%H:%M') }
  end

  def availability(date_time)
    return 'this is an appointment' if kind == 'appointment'

    return { date: starts_at.to_date, slots: open_slots(starts_at) } if weekly_recurring == false

    weekly_difference = date_time.cweek - starts_at.to_date.cweek
    date = (starts_at + weekly_difference.weeks).to_date
    { date:, slots: open_slots(date) }
  end

  def availability?(date)
    return 'this is an appointment' if kind == 'appointment'

    starts_at.wday == date.wday && open_slots(date).any?
  end

  # def self.round_down(starts_at)
  #   Time.at((starts_at.to_f / 30.minutes).round * 30.minutes)
  # end

  private

  def slots_show_time
    slots = Event.slots(starts_at, ends_at)
    slots.map { |date_time| date_time.strftime('%H:%M') }
  end
end
