class Shift < ApplicationRecord
  STATUSES = %w[OPEN CLOSED].freeze

  belongs_to :user

  validates :opening_cash,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }

  validates :actual_closing_cash,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            },
            allow_nil: true

  validates :opened_at, presence: true

  validates :status,
            presence: true,
            inclusion: { in: STATUSES }

  validate :closing_data_matches_status

  private

  def closing_data_matches_status
    if status == "OPEN"
      errors.add(:closed_at, "must be blank while shift is open") if closed_at.present?

      if actual_closing_cash.present?
        errors.add(
          :actual_closing_cash,
          "must be blank while shift is open"
        )
      end
    end

    if status == "CLOSED"
      errors.add(:closed_at, "must be present when shift is closed") if closed_at.blank?

      if actual_closing_cash.nil?
        errors.add(
          :actual_closing_cash,
          "must be present when shift is closed"
        )
      end
    end
  end
end