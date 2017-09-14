class Tagging < ApplicationRecord
  belongs_to :created_by, class_name: 'User'
  belongs_to :song
  belongs_to :tag
  has_many   :types, through: :taggings_type
end
