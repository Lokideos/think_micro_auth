# frozen_string_literal: true

module Sequel::Plugins::SecurePassword
  module InstanceMethods
    include BCrypt

    def password
      @password ||= Password.new(password_digest)
    end

    def password=(new_password)
      @password = Password.create(new_password)
      self.password_digest = @password
    end
  end
end
