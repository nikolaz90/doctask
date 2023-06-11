module Events
  module Scopable
    extend ActiveSupport::Concern

    included do
      scope :openings, -> { where(kind: 'opening') }
      scope :appointments, -> { where(kind: 'appointment') }
    end
  end
end
