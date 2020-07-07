# frozen_string_literal: true

namespace :db do
  desc 'Prints current schema version'
  task version: :settings do
    Sequel.extension :migration

    version = if Sequel.connect(Settings.db.to_hash).tables.include?(:schema_info)
                Sequel.connect(Settings.db.to_hash)[:schema_info].first[:version]
              end || 0

    puts "Schema Version: #{version}"
  end
end
