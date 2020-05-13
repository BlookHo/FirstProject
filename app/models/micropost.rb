class Micropost < ApplicationRecord
  belongs_to :user, dependent: :destroy

  validates :content, length: { maximum: 140 }, presence: true
end
