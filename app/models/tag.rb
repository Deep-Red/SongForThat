class Tag < ApplicationRecord
  belongs_to :added_by, class_name: 'User'
  has_many :taggings
  has_many :tags, through: :taggings
end
