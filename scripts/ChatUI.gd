extends Control

@onready var chat_display = $Panel/VBoxContainer/ChatDisplay
@onready var chat_input = $Panel/VBoxContainer/ChatInput
@onready var send_button = $Panel/VBoxContainer/HBoxContainer/SendButton

func _ready():
	chat_input.text_submitted.connect(_on_chat_submitted)
	send_button.pressed.connect(_on_send_pressed)
	NetworkManager.chat_message_received.connect(_on_chat_message_received)
	
	# Hide input initially
	visible = false

func _input(event):
	if event.is_action_pressed("chat"):
		toggle_chat()

func toggle_chat():
	visible = not visible
	if visible:
		chat_input.grab_focus()
	else:
		chat_input.release_focus()

func _on_send_pressed():
	send_message()

func _on_chat_submitted(_text: String):
	send_message()

func send_message():
	var message = chat_input.text.strip_edges()
	if message.is_empty():
		return
	
	NetworkManager.send_chat_message(message)
	chat_input.text = ""

func _on_chat_message_received(sender: String, message: String):
	var formatted_message = "[%s]: %s\n" % [sender, message]
	chat_display.text += formatted_message
	
	# Auto-scroll to bottom
	await get_tree().process_frame
	chat_display.scroll_vertical = int(chat_display.get_v_scroll_bar().max_value)
