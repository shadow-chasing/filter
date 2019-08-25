class Word::Rankone < ApplicationRecord
    has_many :ranktwos, foreign_key: "word_rankone_id"
end
