namespace :yt do
  desc "Build subtitles"
  task build_subtitles: :environment do
      log = ActiveSupport::Logger.new('log/youtube-filter.log')
      start_time = Time.now
      log.info "Task started at #{start_time} build subtitles."

      ruby "/Users/shadow_chaser/Code/Ruby/Projects/filter/scripts/build/build-subtitles.rb"

      end_time = Time.now
      duration = (start_time - end_time) / 1.minute
      log.info "Task finished at #{end_time} and last #{duration} minutes."
      log.close
  end

  desc "Build categories: builds the category infrastructure each word is then referenced against"
  task build_categories: :environment do
      log = ActiveSupport::Logger.new('log/youtube-filter.log')
      start_time = Time.now
      log.info "Task started at #{start_time} build categories"

      ruby "/Users/shadow_chaser/Code/Ruby/Projects/filter/scripts/build/build-categories.rb"

      end_time = Time.now
      duration = (start_time - end_time) / 1.minute
      log.info "Task finished at #{end_time} and last #{duration} minutes."
      log.close
  end

  desc "Build cross-reference: adds the categories predicate, wordgroup and filter to subtitle.word"
  task build_predicate: :environment do
      log = ActiveSupport::Logger.new('log/youtube-filter.log')
      start_time = Time.now
      log.info "Task started at #{start_time} build cross references"

      ruby "/Users/shadow_chaser/Code/Ruby/Projects/filter/scripts/cross-reference/cross-reference-predicates.rb"

      end_time = Time.now
      duration = (start_time - end_time) / 1.minute
      log.info "Task finished at #{end_time} and last #{duration} minutes."
      log.close
  end

  desc "Build cross-reference: adds the categories predicate, wordgroup and filter to subtitle.word"
  task build_wordgroup: :environment do
      log = ActiveSupport::Logger.new('log/youtube-filter.log')
      start_time = Time.now
      log.info "Task started at #{start_time} build cross references"

      ruby "/Users/shadow_chaser/Code/Ruby/Projects/filter/scripts/cross-reference/cross-reference-wordgroup.rb"

      end_time = Time.now
      duration = (start_time - end_time) / 1.minute
      log.info "Task finished at #{end_time} and last #{duration} minutes."
      log.close
  end

  desc "Build cross-reference: adds the categories predicate, wordgroup and filter to subtitle.word"
  task build_filter: :environment do
      log = ActiveSupport::Logger.new('log/youtube-filter.log')
      start_time = Time.now
      log.info "Task started at #{start_time} build cross references"

      ruby "/Users/shadow_chaser/Code/Ruby/Projects/filter/scripts/cross-reference/cross-reference-filter.rb"

      end_time = Time.now
      duration = (start_time - end_time) / 1.minute
      log.info "Task finished at #{end_time} and last #{duration} minutes."
      log.close
  end

  desc "Build cross-reference: adds the categories predicate, wordgroup and filter to subtitle.word"
  task build_submodalities: :environment do
      log = ActiveSupport::Logger.new('log/youtube-filter.log')
      start_time = Time.now
      log.info "Task started at #{start_time} build cross references"

      ruby "/Users/shadow_chaser/Code/Ruby/Projects/filter/scripts/cross-reference/cross-reference-submodalities.rb"

      end_time = Time.now
      duration = (start_time - end_time) / 1.minute
      log.info "Task finished at #{end_time} and last #{duration} minutes."
      log.close
  end
end
