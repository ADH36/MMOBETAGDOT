extends Node

# WebSocket client for connecting to Node.js server
var socket = WebSocketPeer.new()
var server_url = "ws://localhost:3000"
var connected = false

# Player data
var player_id = ""
var player_name = ""
var other_players = {}

# Signals for networking events
signal connected_to_server
signal disconnected_from_server
signal player_joined(player_data)
signal player_left(player_id)
signal player_moved(player_id, position)
signal chat_message_received(sender, message)

func _ready():
	pass

func connect_to_server(username: String):
	player_name = username
	var error = socket.connect_to_url(server_url)
	if error != OK:
		print("Failed to connect to server: ", error)
		return false
	print("Connecting to server...")
	return true

func _process(_delta):
	socket.poll()
	var state = socket.get_ready_state()
	
	if state == WebSocketPeer.STATE_OPEN:
		if not connected:
			connected = true
			_on_connection_established()
		
		while socket.get_available_packet_count():
			var packet = socket.get_packet()
			var json_string = packet.get_string_from_utf8()
			_handle_server_message(json_string)
	
	elif state == WebSocketPeer.STATE_CLOSED:
		if connected:
			connected = false
			emit_signal("disconnected_from_server")
			print("Disconnected from server")

func _on_connection_established():
	print("Connected to server!")
	# Send authentication message
	send_message({
		"type": "auth",
		"username": player_name
	})
	emit_signal("connected_to_server")

func send_message(data: Dictionary):
	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		var json_string = JSON.stringify(data)
		socket.send_text(json_string)

func send_position(pos: Vector2):
	send_message({
		"type": "move",
		"x": pos.x,
		"y": pos.y
	})

func send_chat_message(message: String):
	send_message({
		"type": "chat",
		"message": message
	})

func _handle_server_message(json_string: String):
	var json = JSON.new()
	var error = json.parse(json_string)
	
	if error != OK:
		print("JSON Parse Error: ", json.get_error_message())
		return
	
	var data = json.data
	
	if typeof(data) != TYPE_DICTIONARY:
		print("Invalid message format")
		return
	
	match data.get("type", ""):
		"auth_success":
			player_id = data.get("player_id", "")
			print("Authenticated with ID: ", player_id)
		
		"player_list":
			var players = data.get("players", [])
			for player in players:
				if player.get("id") != player_id:
					other_players[player.get("id")] = player
					emit_signal("player_joined", player)
		
		"player_joined":
			var player = data.get("player", {})
			if player.get("id") != player_id:
				other_players[player.get("id")] = player
				emit_signal("player_joined", player)
		
		"player_left":
			var left_player_id = data.get("player_id", "")
			if other_players.has(left_player_id):
				other_players.erase(left_player_id)
				emit_signal("player_left", left_player_id)
		
		"player_moved":
			var moved_player_id = data.get("player_id", "")
			if moved_player_id != player_id:
				var position = Vector2(data.get("x", 0), data.get("y", 0))
				emit_signal("player_moved", moved_player_id, position)
		
		"chat":
			var sender = data.get("sender", "Unknown")
			var message = data.get("message", "")
			emit_signal("chat_message_received", sender, message)

func disconnect_from_server():
	if connected:
		send_message({"type": "disconnect"})
		socket.close()
		connected = false
