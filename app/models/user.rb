class User < ApplicationRecord
  ROLES = %w[CASHIER ADMIN].freeze

  validates :pin_hash,
            presence: true

  validates :role,
            presence: true,
            inclusion: { in: ROLES }
end
