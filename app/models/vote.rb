class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates_presence_of :user, :voteable
  validates_uniqueness_of :user_id, scope: [:voteable_id, :voteable_type]
end
