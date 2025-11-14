extends Node

# Currency types
var gold: int = 0  # Free currency - collectable from gameplay
var gems: int = 0  # Premium currency - purchased with real money

# Signals for UI updates
signal currency_changed(currency_type: String, new_amount: int)

func _ready():
	# Load saved currency data
	load_currency()

func add_gold(amount: int):
	"""Add free currency (gold/coins)"""
	if amount > 0:
		gold += amount
		currency_changed.emit("gold", gold)
		save_currency()
		print("Added ", amount, " gold. Total: ", gold)

func add_gems(amount: int):
	"""Add premium currency (gems/crystals)"""
	if amount > 0:
		gems += amount
		currency_changed.emit("gems", gems)
		save_currency()
		print("Added ", amount, " gems. Total: ", gems)

func spend_gold(amount: int) -> bool:
	"""Spend gold if available"""
	if gold >= amount:
		gold -= amount
		currency_changed.emit("gold", gold)
		save_currency()
		print("Spent ", amount, " gold. Remaining: ", gold)
		return true
	else:
		print("Not enough gold! Need: ", amount, " Have: ", gold)
		return false

func spend_gems(amount: int) -> bool:
	"""Spend gems if available"""
	if gems >= amount:
		gems -= amount
		currency_changed.emit("gems", gems)
		save_currency()
		print("Spent ", amount, " gems. Remaining: ", gems)
		return true
	else:
		print("Not enough gems! Need: ", amount, " Have: ", gems)
		return false

func get_gold() -> int:
	return gold

func get_gems() -> int:
	return gems

func save_currency():
	"""Save currency data to file"""
	var save_data = {
		"gold": gold,
		"gems": gems
	}
	var save_file = FileAccess.open("user://currency_data.save", FileAccess.WRITE)
	if save_file:
		save_file.store_var(save_data)
		save_file.close()

func load_currency():
	"""Load currency data from file"""
	if FileAccess.file_exists("user://currency_data.save"):
		var save_file = FileAccess.open("user://currency_data.save", FileAccess.READ)
		if save_file:
			var save_data = save_file.get_var()
			if save_data is Dictionary:
				gold = save_data.get("gold", 0)
				gems = save_data.get("gems", 0)
			save_file.close()
			print("Currency loaded - Gold: ", gold, " Gems: ", gems)
	else:
		# Initialize with starting values
		gold = 0
		gems = 0
		print("No saved currency found. Starting with 0 gold and 0 gems")

func reset_currency():
	"""Reset all currency to 0 (for testing or new game)"""
	gold = 0
	gems = 0
	currency_changed.emit("gold", gold)
	currency_changed.emit("gems", gems)
	save_currency()
