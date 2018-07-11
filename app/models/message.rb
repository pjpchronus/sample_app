class Message < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  validates :sender_id, presence: true
  validates :receiver_id, presence: true
  validates :content, presence: true

  def get_sender
  	User.find(sender_id)
  end
  def get_receiver
  	User.find(receiver_id)
  end
  def self.of_user(user)
  	Message.where(sender_id: user.id).or(Message.where(receiver_id: user.id)).order(:created_at)
  end

  def self.between_users(user, other_user)
  	Message.where(sender_id: user.id, receiver_id: other_user.id).or(Message.where(receiver_id: user.id, sender_id: other_user.id)).order(:created_at)
  end
end

