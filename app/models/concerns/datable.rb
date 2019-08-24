# app/models/concerns/reviewable.rb
#
module Datable
  extend ActiveSupport::Concern

  included do
    has_many :datasets, :as => :datable
  end
end
