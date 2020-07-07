# frozen_string_literal: true

Fabricator(:user_session) do
  uuid { sequence { |n| "uuid_#{n}" } }
  user
end
