require 'sinatra/base'
require 'twilio-ruby'

module IvrToCli
  class App < Sinatra::Base
    get "/" do
      erb :"index.html"
    end

    get "/from_twilio" do
      response = Twilio::TwiML::VoiceResponse.new
      response.gather(input: 'speech', timeout: 3, num_digits: 1, action: "/process_response/0") do |gather|
      end
      response.to_s
    end

    post "/process_response/:number" do
      puts params
      if params['SpeechResult']
        $clients.each { |client| client.send(params['SpeechResult']) }
      end
      response = Twilio::TwiML::VoiceResponse.new
      if $digit_command == ''
        # return XML to try again in N+1 seconds
        response.pause(length: params[:number].to_i)
        response.redirect("/process_response/#{params[:number].to_i + 1}", method: 'POST')
        response.to_s
      else
        response.play(digits: $digit_command)
        response.gather(input: 'speech', timeout: 3, num_digits: 1, action: "/process_response/0") do |gather|
        end
        $digit_command = ''
        response.to_s
      end
    end
  end
end
