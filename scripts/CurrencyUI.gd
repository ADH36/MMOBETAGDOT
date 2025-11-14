extends Control

@onready var gold_label = $Panel/VBoxContainer/GoldContainer/GoldLabel
@onready var gems_label = $Panel/VBoxContainer/GemsContainer/GemsLabel

func _ready():
	# Connect to currency manager signals
	CurrencyManager.currency_changed.connect(_on_currency_changed)
	
	# Initialize display
	update_gold_display(CurrencyManager.get_gold())
	update_gems_display(CurrencyManager.get_gems())

func _on_currency_changed(currency_type: String, new_amount: int):
	"""Update UI when currency changes"""
	match currency_type:
		"gold":
			update_gold_display(new_amount)
		"gems":
			update_gems_display(new_amount)

func update_gold_display(amount: int):
	"""Update gold display"""
	if gold_label:
		gold_label.text = str(amount)

func update_gems_display(amount: int):
	"""Update gems display"""
	if gems_label:
		gems_label.text = str(amount)
