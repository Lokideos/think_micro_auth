# frozen_string_literal: true

module Auth
  class UnknownTokenMode < StandardError; end

  AUTH_TOKEN = /\ABearer (?<token>.+)\z/.freeze

  def extracted_token(token_mode: :http, rpc_token: nil)
    case token_mode
    when :http then JwtEncoder.decode(matched_token)
    when :rpc then JwtEncoder.decode(rpc_token)
    else
      raise UnknownTokenMode
    end
  rescue JWT::DecodeError
    {}
  end

  private

  def matched_token
    result = auth_header&.match(AUTH_TOKEN)
    return if result.blank?

    result[:token]
  end

  def auth_header
    request.env['HTTP_AUTHORIZATION']
  end
end
