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

ActiveRecord::Schema.define(version: 2019_08_24_184156) do

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "datables", force: :cascade do |t|
    t.string "word"
    t.string "datable_type"
    t.integer "datable_id"
    t.index ["datable_type", "datable_id"], name: "index_datables_on_datable_type_and_datable_id"
  end

  create_table "filter_group_rank_ones", force: :cascade do |t|
    t.string "category"
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

  create_table "predicate_group_rank_ones", force: :cascade do |t|
    t.string "category"
  end

  create_table "predicate_group_results", force: :cascade do |t|
    t.string "rank_one"
    t.string "rank_two"
    t.string "group"
    t.string "predicate"
    t.integer "subtitle_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subtitle_id"], name: "index_predicate_group_results_on_subtitle_id"
  end

  create_table "predicate_groups", force: :cascade do |t|
    t.string "category"
  end

  create_table "submodalities_group_rank_ones", force: :cascade do |t|
    t.string "category"
  end

  create_table "submodalities_group_rank_twos", force: :cascade do |t|
    t.string "category"
    t.integer "submodalities_group_rank_one_id"
    t.index ["submodalities_group_rank_one_id"], name: "index_submod_group_rank_two_on_submod_group_rank_one_id"
  end

  create_table "submodalities_group_results", force: :cascade do |t|
    t.string "rank_one"
    t.string "rank_two"
    t.string "group"
    t.string "predicate"
    t.integer "subtitle_id"
    t.index ["subtitle_id"], name: "index_submodalities_group_results_on_subtitle_id"
  end

  create_table "submodalities_groups", force: :cascade do |t|
    t.string "category"
  end

  create_table "subtitles", force: :cascade do |t|
    t.string "word"
    t.string "title"
    t.integer "syllable"
    t.integer "length", default: 0
    t.integer "counter"
    t.integer "duration"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_subtitles_on_category_id"
  end

  create_table "word_group_rank_ones", force: :cascade do |t|
    t.string "category"
  end

  create_table "word_group_rank_threes", force: :cascade do |t|
    t.string "category"
    t.integer "word_group_rank_two_id"
    t.index ["word_group_rank_two_id"], name: "index_word_group_rank_threes_on_word_group_rank_two_id"
  end

  create_table "word_group_rank_twos", force: :cascade do |t|
    t.string "category"
    t.integer "word_group_rank_one_id"
    t.index ["word_group_rank_one_id"], name: "index_word_group_rank_twos_on_word_group_rank_one_id"
  end

  create_table "word_group_results", force: :cascade do |t|
    t.string "rank_one"
    t.string "rank_two"
    t.string "rank_three"
    t.string "group"
    t.string "predicate"
    t.integer "subtitle_id"
    t.index ["subtitle_id"], name: "index_word_group_results_on_subtitle_id"
  end

  create_table "word_groups", force: :cascade do |t|
    t.string "category"
  end

end
