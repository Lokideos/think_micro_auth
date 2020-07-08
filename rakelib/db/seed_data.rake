# frozen_string_literal: true

require_relative '../../config/environment'

namespace :db do
  desc 'Seed data into database'
  task :seed => :settings do
    Sequel.connect(Settings.db.to_hash) do |db|
      db.transaction do
        require_relative '../../db/seeds'
      end
    end
  end
end
