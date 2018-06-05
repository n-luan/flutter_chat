class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :device_tokens, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_one :user_room, dependent: :destroy

  validates :name, presence: true

  def unread_count
    Message.unread(user_room.read_at, id).size
  end
end
