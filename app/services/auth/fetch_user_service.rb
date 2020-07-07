# frozen_string_literal: true

module Auth
  class FetchUserService
    prepend BasicService

    param :uuid

    attr_reader :user

    def call
      if @uuid.blank? || session.blank?
        return fail!(I18n.t(:forbidden, scope: 'services.auth.fetch_user_service'))
      end

      @user = session.user
    end

    private

    def session
      @session ||= UserSession.find(uuid: @uuid)
    end
  end
end
