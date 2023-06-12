module Events
  module Scopable
    extend ActiveSupport::Concern

    included do
      scope :openings, -> {
        where(kind: 'opening')
      }
      scope :openings_today, ->(start_time) {
        where(kind: 'opening').and(where('starts_at BETWEEN ? AND ?', start_time, start_time.end_of_day))
      }
      scope :appointments_today, ->(start_time) {
        where(kind: 'appointment').and(where('starts_at BETWEEN ? AND ?', start_time, start_time.end_of_day))
      }
    end
  end
end
