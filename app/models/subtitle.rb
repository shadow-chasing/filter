class Subtitle < ApplicationRecord

  # belongs to
  belongs_to :category

  # has many
  has_many :predicate_group_results, dependent: :destroy
  has_many :submodalities_group_results, dependent: :destroy
  has_many :word_group_results, dependent: :destroy
  has_many :theme_group_results, dependent: :destroy

  def self.syllable_count
    pluck(:syllable).sum
  end
  
end
