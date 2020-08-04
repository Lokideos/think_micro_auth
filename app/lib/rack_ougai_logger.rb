# frozen_string_literal: true

module Rack
  module Ougai
    class Logger
      def initialize(app, level = ::Logger::INFO)
        @app = app
        @level = level
      end

      def call(env)
        if Application.environment == :development
          logger = ::Ougai::Logger.new(env[RACK_ERRORS], level: Settings.logger.level)
          logger.formatter = ::Ougai::Formatters::Readable.new
        else
          logger = ::Ougai::Logger.new(
            Application.root.concat('/', Settings.logger.path),
            level: Settings.logger.level
          )
        end
        logger.before_log = lambda do |data|
          data[:service] = { name: Settings.app.name }
          data[:request_id] ||= Thread.current[:request_id]
        end

        env[RACK_LOGGER] = logger
        @app.call(env)
      end
    end

    class RequestLogger
      def initialize(app, logger = nil)
        @app = app
        @logger = logger
      end

      def call(env)
        status, headers, body = @app.call(env)
      ensure
        logger = @logger || env[RACK_LOGGER]
        logger.before_log = lambda do |data|
          data[:service] = { name: Settings.app.name }
          data[:request_id] ||= Thread.current[:request_id]
        end
        logger.info('HTTP Request', create_log(env, status, headers))
      end

      private

      def create_log(env, status, _header)
        {
          time: Time.now,
          remote_addr: env['HTTP_X_FORWARDED_FOR'] || env['REMOTE_ADDR'],
          method: env[REQUEST_METHOD],
          path: env[PATH_INFO],
          query: env[QUERY_STRING],
          status: status.to_i
        }
      end
    end
  end
end
