class Event < ApplicationRecord
  include Events::Scopable

  def self.availabilities(date_time)
    upcoming_events = upcoming_openings(date_time)
    availability_hashes = 7.times.map { |i| { date: date_time.to_date + i.days, slots: [] } }

    availability_hashes.each do |availability|
      upcoming_events.each do |event|
        availability[:slots] = event.open_slots(availability[:date]) if event.availability?(availability[:date])
      end
    end
  end

  def booked_slots
    return 'this is an opening' if kind == 'opening'

    slots_show_time
  end

  def open_slots(availability_date)
    return 'this is an appointment' if kind == 'appointment'

    bookings = Event.appointments_today(availability_date).map(&:booked_slots).flatten
    filtered_slots = slots.reject! { |date_time| bookings.include?(date_time.strftime('%H:%M')) }
    filtered_slots.map { |date_time| date_time.strftime('%H:%M') }
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


  private

  def slots
    number_of_half_hours = ((ends_at - starts_at) / 1.hour).floor * 2
    number_of_half_hours.times.map { |i| starts_at + i * 30.minutes }
  end

  def slots_show_time
    slots.map { |date_time| date_time.strftime('%H:%M') }
  end

  # def self.round_down(starts_at)
  #   Time.at((starts_at.to_f / 30.minutes).round * 30.minutes)
  # end
end
