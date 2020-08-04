# frozen_string_literal: true

class Application < Roda
  plugin :error_handler
  plugin(:not_found) { { error: 'Not found' } }
  plugin :environments
  plugin(:json_parser)
  include Errors
  include Validations
  include ApiErrors
  include Auth

  route do |r|
    r.root do
      response['Content-Type'] = 'application/json'
      response.status = 200
      { status: 'ok' }.to_json
    end

    r.on 'v1' do
      r.on 'signup' do
        r.post do
          user_params = validate_with!(UserParamsContract, params).to_h.values
          result = Users::CreateService.call(*user_params)
          response['Content-Type'] = 'application/json'

          if result.success?
            response.status = 201
            { status: 'created' }.to_json
          else
            response.status = 422
            error_response(result.user)
          end
        end
      end

      r.on 'login' do
        r.post do
          session_params = validate_with!(SessionParamsContract, params).to_h.values
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

      r.on 'auth' do
        r.post do
          result = Auth::FetchUserService.call(extracted_token['uuid'])
          response['Content-Type'] = 'application/json'

          if result.success?
            meta = { user_id: result.user.id }

            response.status = 200
            { meta: meta }.to_json
          else
            response.status = 403
            error_response(result.errors)
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
