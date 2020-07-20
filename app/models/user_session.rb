# frozen_string_literal: true

class UserSession < Sequel::Model
  plugin :uuid
  plugin :model_validations

  many_to_one :user

  def valid?
    validate_with(UserSessionsContract, values).success?
  end

  def validate
    super

    validate_with!(UserSessionsContract, values)
  end

  def errors
    validate_with(UserSessionsContract, values).errors.to_h
  end
end
