class Event < ApplicationRecord
  include Events::Scopable

  def self.availabilities(date_time)
    upcoming_events = upcoming_openings(date_time)
    availabilities = 7.times.map { |i| { date: date_time.to_date + i.days, slots: [] } }

    availabilities.each do |availability|
      upcoming_events.each do |event|
        availability[:slots] = event.open_slots(availability[:date]) if event.available?(availability[:date])
      end
    end
  end

  def open_slots(availability_date)
    raise NoMethodError, 'Error: this is an appointment and does not have an open slots method' if kind == 'appointment'

    bookings = self.class.appointments_today(availability_date).map(&:slots_show_time).flatten
    filtered_slots = slots.reject! { |date_time| bookings.include?(date_time.strftime('%-l:%M')) }
    filtered_slots.map { |date_time| date_time.strftime('%-l:%M') }
  end

  def available?(date)
    raise NoMethodError, 'Error: this is an appointment and does not have an available? method' if kind == 'appointment'

    starts_at.wday == date.wday && open_slots(date).any?
  end

  def slots_show_time
    slots.map { |date_time| date_time.strftime('%-l:%M') }
  end

  private

  def slots
    number_of_half_hours = ((ends_at - starts_at) / 30.minutes).floor
    number_of_half_hours.times.map { |i| starts_at + (i * 30.minutes) }
  end

  def availability(date_time)
    raise NoMethodError, 'Error: this is an appointment and does not have an availability method' if kind == 'appointment'

    return { date: starts_at.to_date, slots: open_slots(starts_at) } if weekly_recurring == false

    difference_in_weeks = date_time.cweek - starts_at.to_date.cweek
    date = (starts_at + difference_in_weeks.weeks).to_date
    { date:, slots: open_slots(date) }
  end

  # def self.round_down(starts_at)
  #   Time.at((starts_at.to_f / 30.minutes).round * 30.minutes)
  # end
end
