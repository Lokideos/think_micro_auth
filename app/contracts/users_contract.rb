# frozen_string_literal: true

class UsersContract < Dry::Validation::Contract
  NAME_FORMAT = /\A\w+\z/.freeze

  schema do
    required(:name).filled(:string)
    required(:email).filled(:string)
    required(:password_digest).filled(:string)
  end

  rule(:name) do
    key.failure(I18n.t(:format, scope: 'model.errors.user.name')) unless value.match? NAME_FORMAT
  end
end
