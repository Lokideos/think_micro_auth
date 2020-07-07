# frozen_string_literal: true

require 'sequel/core'

namespace :db do
  desc 'Drop database'
  task drop: :settings do
    db_settings = Settings.db.to_hash
    db_url = "postgres://#{db_settings[:user]}:#{db_settings[:password]}@" +
      "#{db_settings[:host]}:#{db_settings[:port]}"

    Sequel.connect(db_url) do |db|
      db.execute "DROP DATABASE #{Settings.db.to_hash[:database]}"
    end
  end
end
