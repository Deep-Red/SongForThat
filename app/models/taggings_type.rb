class TaggingsType < ApplicationRecord
  belongs_to :tagging_id
  belongs_to :type_id
end
