class Datable < ApplicationRecord
  belongs_to :datable, polymorphic: true
end
