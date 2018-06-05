class Message < ApplicationRecord
  belongs_to :user
  delegate :id, :name, to: :user, prefix: true, allow_nil: true

  scope :unread, -> read_at, user_id do
    where("messages.user_id != ?", user_id)
    .where(" ? < (SELECT MAX(messages.created_at))", read_at.try(:utc))
  end
end
