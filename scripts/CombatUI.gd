extends CanvasLayer

@onready var health_bar = $Panel/VBoxContainer/HealthBar
@onready var mana_bar = $Panel/VBoxContainer/ManaBar
@onready var health_label = $Panel/VBoxContainer/HealthBar/Label
@onready var mana_label = $Panel/VBoxContainer/ManaBar/Label
@onready var skill_container = $SkillBar/HBoxContainer

var character_data: CharacterData

func _ready():
	pass

func _process(_delta):
	if character_data:
		update_bars()

func set_character_data(char_data: CharacterData):
	"""Set the character data to display"""
	character_data = char_data
	update_bars()
	setup_skill_indicators()

func update_bars():
	"""Update health and mana bars"""
	if not character_data:
		return
	
	# Update health
	var health_percent = float(character_data.current_health) / float(character_data.max_health)
	if health_bar:
		health_bar.value = health_percent * 100
	if health_label:
		health_label.text = "%d / %d" % [character_data.current_health, character_data.max_health]
	
	# Update mana
	var mana_percent = float(character_data.current_mana) / float(character_data.max_mana)
	if mana_bar:
		mana_bar.value = mana_percent * 100
	if mana_label:
		mana_label.text = "%d / %d" % [character_data.current_mana, character_data.max_mana]
	
	# Update skill cooldowns
	update_skill_indicators()

func setup_skill_indicators():
	"""Setup skill indicator slots"""
	if not skill_container or not character_data:
		return
	
	# Clear existing indicators
	for child in skill_container.get_children():
		child.queue_free()
	
	# Create skill indicators
	for i in range(character_data.skills.size()):
		var skill_panel = Panel.new()
		skill_panel.custom_minimum_size = Vector2(60, 60)
		skill_panel.name = "Skill%d" % i
		
		var vbox = VBoxContainer.new()
		skill_panel.add_child(vbox)
		
		var skill_name_label = Label.new()
		skill_name_label.text = character_data.skills[i].skill_name
		skill_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		skill_name_label.add_theme_font_size_override("font_size", 10)
		vbox.add_child(skill_name_label)
		
		var cooldown_label = Label.new()
		cooldown_label.name = "Cooldown"
		cooldown_label.text = ""
		cooldown_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vbox.add_child(cooldown_label)
		
		var key_label = Label.new()
		key_label.text = str(i + 1)
		key_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		key_label.add_theme_font_size_override("font_size", 12)
		vbox.add_child(key_label)
		
		skill_container.add_child(skill_panel)

func update_skill_indicators():
	"""Update skill cooldown displays"""
	if not skill_container or not character_data:
		return
	
	for i in range(character_data.skills.size()):
		var skill_panel = skill_container.get_node_or_null("Skill%d" % i)
		if skill_panel:
			var cooldown_label = skill_panel.find_child("Cooldown", true, false)
			if cooldown_label:
				var skill = character_data.skills[i]
				if skill.current_cooldown > 0:
					cooldown_label.text = "%.1f" % skill.current_cooldown
				else:
					cooldown_label.text = "Ready"
