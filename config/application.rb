# frozen_string_literal: true

class Application < Roda
  plugin :error_handler do |e|
    case e
    when Sequel::NoMatchingRow
      response.status = 422
      error_response I18n.t(:not_found, scope: 'api.errors')
    when Sequel::UniqueConstraintViolation
      response.status = 422
      error_response I18n.t(:not_unique, scope: 'api.errors')
    when Validations::InvalidParams, KeyError
      response.status = 422
      error_response I18n.t(:missing_parameters, scope: 'api.errors')
    else
      raise
    end
  end
  plugin(:not_found) { { error: 'Not found' } }
  plugin :environments
  plugin(:json_parser)
  include Validations
  include ApiErrors

  route do |r|
    r.root do
      response['Content-Type'] = 'application/json'
      response.status = 200
      JSON({ status: 'ok' })
    end

    r.on 'v1' do
      r.on 'users' do
        r.post do
          user_params = validate_with!(UserParamsContract).to_h.values
          result = Users::CreateService.call(*user_params)
          response['Content-Type'] = 'application/json'

          if result.success?
            response.status = 201
            JSON({ status: 'created' })
          else
            error_response(result.user)
          end
        end
      end

      r.on 'sessions' do
        r.post do
          session_params = validate_with!(SessionParamsContract).to_h.values
          result = UserSessions::CreateService.call(*session_params)
          response['Content-Type'] = 'application/json'

          if result.success?
            token = JwtEncoder.encode(uuid: result.session.uuid)
            meta = { token: token }

            response.status = 201
            { meta: meta }.to_json
          else
            response.status = 401
            error_response(result.session || result.errors)
          end
        end
      end
    end

    r.get 'favicon.ico' do
      'no icon'
    end
  end

  private

  def params
    request.params
  end
end
