# frozen_string_literal: true

require 'sequel/core'

namespace :db do
  desc 'Create database'
  task create: :settings do
    db_settings = Settings.db.to_hash
    db_url = "postgres://#{db_settings[:user]}:#{db_settings[:password]}@" +
      "#{db_settings[:host]}:#{db_settings[:port]}"

    Sequel.connect(db_url) do |db|
      db.execute "CREATE DATABASE #{Settings.db.to_hash[:database]}"
    end
    Rake::Task['db:add_extensions'].execute
  end
end
