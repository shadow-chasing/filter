class Category < ApplicationRecord
    has_many :subtitles, dependent: :destroy
end
