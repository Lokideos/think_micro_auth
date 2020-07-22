# frozen_string_literal: true

class User < Sequel::Model
  plugin :association_dependencies
  plugin :secure_password, include_validations: false
  plugin :model_validations

  NAME_FORMAT = /\A\w+\z/.freeze

  one_to_many :sessions, class: 'UserSession'

  add_association_dependencies sessions: :delete

  def valid?
    validate_with(UsersContract, values).success?
  end

  def validate
    super

    validate_with!(UsersContract, values)
  end

  def errors
    validate_with(UsersContract, values).errors.to_h
  end
end
