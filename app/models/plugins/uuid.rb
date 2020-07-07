# frozen_string_literal: true

module Sequel::Plugins::Uuid
  module InstanceMethods
    def before_validation
      set_uuid
      super
    end

    private

    def set_uuid
      self.uuid = SecureRandom.uuid
    end
  end
end
