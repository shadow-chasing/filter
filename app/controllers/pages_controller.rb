class PagesController < ApplicationController
  def results

    # subtitles counts
    @subtitles = Subtitle.all

    # scoping group categories to sum results
    @religion = scope_group(FilterGroupResult, :"religion-and-spirituality")
    @profanity = scope_group(FilterGroupResult, :profanity)

    # scope wordgroup and sum each category
    @verb = scope_group(WordGroupResult, :verb)
    @conjunction = scope_group(WordGroupResult, :conjunction)
    @noun = scope_group(WordGroupResult, :noun)
    @pronoun = scope_group(WordGroupResult, :pronoun)
    @adjective = scope_group(WordGroupResult, :adjective)

    # scope predicates and sum each category
    @audio = scope_predicate(:auditory)
    @olfactory = scope_predicate(:olfactory)
    @visual = scope_predicate(:visual)
    @kinesthetic = scope_predicate(:kinesthetic)
    @gustatory = scope_predicate(:gustatory)
  end

  # takes two args groupresult and category of group
  def scope_group(*args)
      Subtitle.where(id: args[0].where(group: args[1]).pluck(:subtitle_id))
  end

  # takes two args groupresult and category of group
  def scope_predicate(*args)
      Subtitle.where(id: PredicateResult.where(predicate: args[0]).pluck(:subtitle_id))
  end

end
