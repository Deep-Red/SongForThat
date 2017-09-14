class Type < ApplicationRecord
  has_many   :tags, through: :taggings_type
end
