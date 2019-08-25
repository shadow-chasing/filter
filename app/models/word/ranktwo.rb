class Word::Ranktwo < ApplicationRecord
    belongs_to :rankone
    has_many :rankthrees, foreign_key: "word_ranktwo_id"
end
