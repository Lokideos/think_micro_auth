# frozen_string_literal: true

class UserSessionsContract < Dry::Validation::Contract
  schema do
    required(:user_id).filled(:integer)
  end
end
