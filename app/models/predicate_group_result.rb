class PredicateGroupResult < ApplicationRecord
    #--------------------------------------------------------------------------
    # assosiations
    #--------------------------------------------------------------------------
    # polymorphic assosiation
    include Datable

    # belongs to assosiation
    belongs_to :subtitle
end
