class DeviceToken < ApplicationRecord
  validates :token, presence: true, uniqueness: true
end
