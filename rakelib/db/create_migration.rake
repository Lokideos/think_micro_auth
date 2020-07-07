# frozen_string_literal: true

namespace :db do
  desc 'Create database migration'
  task :create_migration, [:name] do |_task, args|
    version = DateTime.now.strftime("%Y%m%d%H%M%S")
    filepath = File.join(__dir__, '../../db/migrations', "#{version}_#{args.name}.rb")
    migration_boilerplate = "# frozen_string_literal: true\n\n" \
                            "Sequel.migration do\n  up do\n\n  end\n\n  down do\n\n  end\nend"

    File.write(filepath, migration_boilerplate)
  end
end
