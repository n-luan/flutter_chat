class Message < ApplicationRecord
  belongs_to :user
  delegate :id, :name, to: :user, prefix: true, allow_nil: true
end
