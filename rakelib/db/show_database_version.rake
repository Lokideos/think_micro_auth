# frozen_string_literal: true

namespace :db do
  desc 'Prints current schema version'
  task version: :settings do
    Sequel.extension :migration

    DB = Sequel.connect(Settings.db.to_hash)

    version = if DB.tables.include?(:schema_migrations)
                DB[:schema_migrations].first[:filename]
              end || 0

    puts "Last Migration: #{version}"
  end
end
