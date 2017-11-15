require 'websocket-client-simple'

ws = WebSocket::Client::Simple.connect 'ws://localhost:5000'

ws.on :message do |msg|
  puts msg.data
  puts msg
end

ws.on :open do
  ws.send 'hello!!!'
end

ws.on :close do |e|
  p e
  exit 1
end

ws.on :error do |e|
  p e
end

loop do
  ws.send STDIN.gets.strip
end
