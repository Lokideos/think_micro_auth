# frozen_string_literal: true

include Auth

channel = RabbitMq.consumer_channel
exchange = channel.default_exchange
queue = channel.queue('auth', durable: true)

queue.subscribe do |_delivery_info, properties, payload|
  payload = JSON(payload)
  Thread.current[:request_id] = properties.headers['request_id']
  result = Auth::FetchUserService.call(
    extracted_token(token_mode: :rpc,
                    rpc_token: payload['token'])['uuid']
  )

  Application.logger.info(
    'authenticate_user',
    token: payload['token'],
    user_id: result.user&.id
  )

  exchange.publish(
    { user_id: result.user&.id }.to_json,
    routing_key: properties.reply_to,
    correlation_id: properties.correlation_id
  )
end
