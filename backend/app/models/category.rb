class Category < ApplicationRecord
  validates :name,
            presence: true,
            length: { maximum: 100 }

  validates :sort_order,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }
end