# frozen_string_literal: true

# For proper debug
# if Application.environment == :development
#   logger = Ougai::Logger.new(STDOUT, level: Settings.logger.level)
#   logger.formatter = Ougai::Formatters::Readable.new
# else
#   logger = Ougai::Logger.new(
#     Application.root.concat('/', Settings.logger.path),
#     level: Settings.logger.level
#   )
# end

logger = Ougai::Logger.new(
  Application.root.concat('/', Settings.logger.path),
  level: Settings.logger.level
)
logger.before_log = lambda do |data|
  data[:service] = { name: Settings.app.name }
  data[:request_id] ||= Thread.current[:request_id]
end
Application.logger = logger

Sequel::Model.db.loggers.push(Application.logger)
