require 'faye/websocket'
require 'json'
require 'erb'
require 'twilio-ruby'

module IvrToCli
  class WebSocketBackend
    KEEPALIVE_TIME = 15 # in seconds

    def initialize(app)
      @app = app
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME })
        ws.on :open do |event|
          puts [:open, ws.object_id]
          $clients << ws
        end

        ws.on :message do |event|
          puts [:message, event.data]
          $messages << event.data
          $clients.each { |client| client.send("COPY " + event.data) }

          if event.data[0..3] == 'call'
            url = "#{ENV['NGROK_URL']}/from_twilio"
            to_phone_number = event.data[5..-1]
            from_phone_number = ENV['TWILIO_PHONE_NUMBER']
            sid = ENV['TWILIO_SID']
            auth_token = ENV['TWILIO_AUTH_TOKEN']
            @client = Twilio::REST::Client.new(sid, auth_token)

            @call = @client.calls.create(
              url: url,
              method: 'GET',
              to: to_phone_number,
              from: from_phone_number
            )

            puts "Call initiated with SID: #{@call.sid}"
          elsif event.data
            $digit_command = event.data
          end
        end

        ws.on :close do |event|
          p [:close, ws.object_id, event.code, event.reason]
          $clients.delete(ws)
          ws = nil
        end

        # Return async Rack response
        ws.rack_response

      else
        @app.call(env)
      end
    end
  end
end
