module Events
  module Scopable
    extend ActiveSupport::Concern

    included do
      scope :upcoming_openings, ->(date_time) {
        where(
          kind: 'opening',
          weekly_recurring: true
        ).or(
          where(
            kind: 'opening',
            weekly_recurring: false
          ).and(
            where(
              'starts_at BETWEEN ? AND ?', date_time, date_time + 7.days
            )
          )
        )
      }

      scope :appointments_today, ->(start_time) {
        where(kind: 'appointment').and(where('starts_at BETWEEN ? AND ?', start_time, start_time.end_of_day))
      }
    end
  end
end
