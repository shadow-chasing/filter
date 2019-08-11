# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_08_11_170105) do

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "filter_datasets", force: :cascade do |t|
    t.string "word"
  end

  create_table "filter_group_rank_ones", force: :cascade do |t|
    t.string "category"
    t.integer "filter_group_id"
    t.index ["filter_group_id"], name: "index_filter_group_rank_ones_on_filter_group_id"
  end

  create_table "filter_group_rank_twos", force: :cascade do |t|
    t.string "category"
    t.integer "filter_group_rank_one_id"
    t.index ["filter_group_rank_one_id"], name: "index_filter_group_rank_twos_on_filter_group_rank_one_id"
  end

  create_table "filter_group_results", force: :cascade do |t|
    t.string "rank_one"
    t.string "rank_two"
    t.string "group"
    t.string "predicate"
    t.integer "subtitle_id"
    t.index ["subtitle_id"], name: "index_filter_group_results_on_subtitle_id"
  end

  create_table "filter_groups", force: :cascade do |t|
    t.string "category"
  end

  create_table "filter_rank_one_records", force: :cascade do |t|
    t.integer "filter_group_rank_one_id"
    t.integer "filter_dataset_id"
    t.index ["filter_dataset_id"], name: "index_filter_rank_one_records_on_filter_dataset_id"
    t.index ["filter_group_rank_one_id"], name: "index_filter_rank_one_records_on_filter_group_rank_one_id"
  end

  create_table "filter_rank_two_records", force: :cascade do |t|
    t.integer "filter_group_rank_two_id"
    t.integer "filter_dataset_id"
    t.index ["filter_dataset_id"], name: "index_filter_rank_two_records_on_filter_dataset_id"
    t.index ["filter_group_rank_two_id"], name: "index_filter_rank_two_records_on_filter_group_rank_two_id"
  end

  create_table "nodes", force: :cascade do |t|
    t.integer "node"
    t.integer "sentence_id"
    t.index ["sentence_id"], name: "index_nodes_on_sentence_id"
  end

  create_table "paragraphs", force: :cascade do |t|
    t.integer "paragraph"
    t.string "title"
  end

  create_table "personality_datasets", force: :cascade do |t|
    t.string "word"
    t.integer "personality_group_id"
    t.index ["personality_group_id"], name: "index_personality_datasets_on_personality_group_id"
  end

  create_table "personality_groups", force: :cascade do |t|
    t.string "category"
  end

  create_table "personality_results", force: :cascade do |t|
    t.string "rank_one"
    t.string "rank_two"
    t.string "group"
    t.integer "subtitle_id"
    t.index ["subtitle_id"], name: "index_personality_results_on_subtitle_id"
  end

  create_table "predicate_datasets", force: :cascade do |t|
    t.string "word"
    t.integer "predicate_group_id"
    t.index ["predicate_group_id"], name: "index_predicate_datasets_on_predicate_group_id"
  end

  create_table "predicate_groups", force: :cascade do |t|
    t.string "category"
  end

  create_table "predicate_results", force: :cascade do |t|
    t.string "rank_one"
    t.string "rank_two"
    t.string "group"
    t.string "predicate"
    t.integer "subtitle_id"
    t.index ["subtitle_id"], name: "index_predicate_results_on_subtitle_id"
  end

  create_table "sentences", force: :cascade do |t|
    t.integer "sentence"
    t.integer "paragraph_id"
    t.index ["paragraph_id"], name: "index_sentences_on_paragraph_id"
  end

  create_table "subtitles", force: :cascade do |t|
    t.string "word"
    t.string "title"
    t.integer "counter"
    t.integer "length", default: 0
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "syllable", default: 0
    t.time "duration"
    t.index ["category_id"], name: "index_subtitles_on_category_id"
  end

  create_table "syntaxes", force: :cascade do |t|
    t.integer "paragraph"
    t.integer "sentence"
    t.integer "node"
    t.string "word"
  end

  create_table "word_datasets", force: :cascade do |t|
    t.string "word"
  end

  create_table "word_group_rank_ones", force: :cascade do |t|
    t.string "category"
    t.integer "word_group_id"
    t.index ["word_group_id"], name: "index_word_group_rank_ones_on_word_group_id"
  end

  create_table "word_group_rank_twos", force: :cascade do |t|
    t.string "category"
    t.integer "word_group_rank_one_id"
    t.index ["word_group_rank_one_id"], name: "index_word_group_rank_twos_on_word_group_rank_one_id"
  end

  create_table "word_group_results", force: :cascade do |t|
    t.string "rank_one"
    t.string "rank_two"
    t.string "group"
    t.string "predicate"
    t.integer "subtitle_id"
    t.index ["subtitle_id"], name: "index_word_group_results_on_subtitle_id"
  end

  create_table "word_groups", force: :cascade do |t|
    t.string "category"
  end

  create_table "word_rank_one_records", force: :cascade do |t|
    t.integer "word_group_rank_one_id"
    t.integer "word_dataset_id"
    t.index ["word_dataset_id"], name: "index_word_rank_one_records_on_word_dataset_id"
    t.index ["word_group_rank_one_id"], name: "index_word_rank_one_records_on_word_group_rank_one_id"
  end

  create_table "word_rank_two_records", force: :cascade do |t|
    t.integer "word_group_rank_two_id"
    t.integer "word_dataset_id"
    t.index ["word_dataset_id"], name: "index_word_rank_two_records_on_word_dataset_id"
    t.index ["word_group_rank_two_id"], name: "index_word_rank_two_records_on_word_group_rank_two_id"
  end

end
