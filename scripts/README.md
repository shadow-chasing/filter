# Data

### scripts

These should be built in order.


1. get_data.rb
2. build_categories.rb
3. cross-reference-predicates
4. cross-reference-wordgroup
5. modality_score




### Subtitle

```ruby
    ####<Subtitle:0x00001aa149693348> {
             :id => 1,
           :word => "another",
          :title => "NotTooDeep",
        :counter => 100
    }
```

## Predicate Filter
Subtitles contain each individual word from any subtitle. Each word contains a count for how many occurrences of the word there is. Words are filtered through the predicate list and the appropriate category is added. The result is a join though a has and belongs to association with PredicateResult and Subtitle. PredicateResult contains a subtitle_id.

### PredicateResults

```ruby
    ####<PredicateResult:0x00001aij101111a0> {
      :id => 1,
      :group => "predicate",
      :rank_one => "kinesthetic",
      :rank_two => nil,
      :subtitle_id => 1
    }
```

## Word Group Filter
Subtitles are then filtered through word group where they are categorized into the appropriate word classes. There is also a filter through the adjective categories - category_predicates where predicate subclasses are added.

### WordGroupResults

```ruby
    ####<WordGroupResult:0x00001aa01aa1c1> {
      :id => 1,
      :group => "adjective",
      :rank_one => "category_predicates",
      :rank_two => "sound",
      :predicate => "auditory",
      :subtitle_id => 1
    },
```

## ModalityScore
Finds each word that has a record. This word will have a count, and associated records, possibly one from each of the Results Predicate and WordGroup. If the word then has a count of 20 occurrences and a record from the PredicateResult for Vision a count of 20 is added to the ModalityScore Visual column. This score is incremented.


```ruby
    ####<ModalityScore:0x00001aaa02a96998> {
                 :id => 1,
             :visual => 0,
           :auditory => 0,
        :kinesthetic => 0,
          :gustatory => 0,
           :olfactor => 0,
            :primary => nil,
          :secondary => nil
    }
```

# TODO
1. Find uniq column for predicates on both results.
2. Cross-reference subtitle word results, WordGroupResults and PredicateResult
returning only uniq results. Ultimately one word can have many different predicates but never more than one for the same category.
3. Add count for each individual predicate to ModalityScore.
4. Count the column for the highest score and add the column name to the primary column, second highest score is added to the secondary column.
4. Personality group


### Directory structure

* modality-group
  - audio-digital
  - auditory
  - gustatory
  - kinesthetic
  - olfactory
  - visual
* personality-group
* predicate-group
  - auditory
  - gustatory
  - kinesthetic
  - olfactory
  - visual
* word-group
  - adjective
    - category_predicates
      * adjective
      * age
      * color
      * compound
      * condition
      * feelings
      * material
      * qualaties-and-appearence
      * quantity
      * shape
      * size
      * tase-and-touch
      * time
      * weather

    - descriptive
      * comparative
      * posative
      * superlative
    - limiting
      * cardinal
      * definite-and-indefinite
      * demonstrative
      * distributive
      * interrogative
      * ordinal
      * possessive
      * proper

  - conjunction
    - adverb
    - coordinating
    - subordinating
  - noun
    - abstract
    - collective
    - common
    - countable
    - literal
    - plural
    - proper
    - uncountable
  - pronoun
    - demonstrative
    - indesinite
    - interrogative
    - object
    - personal
    - possessive
    - pronouns
    - reflexive
    - relative
  - verb
    - action
    - helping
    - intransitive
    - irregular
    - linking
    - regular
    - transitive
