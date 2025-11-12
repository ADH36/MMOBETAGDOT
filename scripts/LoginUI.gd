extends Control

@onready var username_input = $Panel/VBoxContainer/UsernameInput
@ontml:parameter name="server_input = $Panel/VBoxContainer/ServerInput
@onready var connect_button = $Panel/VBoxContainer/ConnectButton
@onready var status_label = $Panel/VBoxContainer/StatusLabel

signal login_successful(username)

func _ready():
	connect_button.pressed.connect(_on_connect_pressed)
	NetworkManager.connected_to_server.connect(_on_connected_to_server)
	NetworkManager.disconnected_from_server.connect(_on_disconnected)

func _on_connect_pressed():
	var username = username_input.text.strip_edges()
	var server_url = server_input.text.strip_edges()
	
	if username.is_empty():
		status_label.text = "Please enter a username"
		return
	
	if not server_url.is_empty():
		NetworkManager.server_url = server_url
	
	status_label.text = "Connecting to server..."
	connect_button.disabled = true
	
	NetworkManager.connect_to_server(username)

func _on_connected_to_server():
	status_label.text = "Connected! Entering game..."
	await get_tree().create_timer(0.5).timeout
	emit_signal("login_successful", username_input.text.strip_edges())
	queue_free()

func _on_disconnected():
	status_label.text = "Disconnected from server"
	connect_button.disabled = false
