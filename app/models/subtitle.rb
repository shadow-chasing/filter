class Subtitle < ApplicationRecord

  # belongs to
  belongs_to :category

  # has many
  has_many :modality_results, dependent: :destroy
  has_many :personality_results, dependent: :destroy
  has_many :predicate_results, dependent: :destroy
  has_many :word_group_results, dependent: :destroy
  has_many :filter_group_results, dependent: :destroy

  def self.word_length(operand="==", size)
    where("length" + operand + "?", size)
  end

  def self.syllable_count
    pluck(:syllable).sum
  end
  
end
