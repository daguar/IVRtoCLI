require './app'
require './middlewares/web_socket_backend'

$messages = []
$clients = []
$digit_command = ''

use IvrToCli::WebSocketBackend
run IvrToCli::App
