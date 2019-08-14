class PagesController < ApplicationController
  def results
    @subtitles = Subtitle.where(title: sub_title)
    # scoping group categories to sum results
    @religion = scope_group(FilterGroupResult, :"religion-and-spirituality")
    @profanity = scope_group(FilterGroupResult, :profanity)
    @political = scope_group(FilterGroupResult, :political)

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

  # uses the find_by which returns the first occurence of the result then
  # retrives the title attribute.
  def sub_title
    # subtitles counts
    @title = Subtitle.find_by(id: params[:format]).title
  end

  # takes two args groupresult and category of group, also passes in the title
  # instance variable to make sure the ecords returned are only for the
  # specific title not all the titles.
  def scope_group(*args)
      Subtitle.where(id: args[0].where(group: args[1]).pluck(:subtitle_id), title: sub_title)
  end

  # takes two args groupresult and category of group
  def scope_predicate(*args)
      Subtitle.where(id: PredicateResult.where(predicate: args[0]).pluck(:subtitle_id))
  end

end
