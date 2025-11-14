extends CanvasLayer

signal skill_upgraded(skill_index: int)

@onready var panel = $Panel
@onready var skills_container = $Panel/ScrollContainer/VBoxContainer

var character_data: CharacterData
var is_visible_ui: bool = false

func _ready():
	hide_ui()

func _input(event):
	# Toggle skill upgrade UI with 'U' key
	if event.is_action_pressed("ui_page_up"):  # Using existing Godot action
		toggle_ui()

func toggle_ui():
	"""Toggle skill upgrade UI visibility"""
	is_visible_ui = not is_visible_ui
	if is_visible_ui:
		show_ui()
	else:
		hide_ui()

func show_ui():
	"""Show the skill upgrade UI"""
	if panel:
		panel.visible = true
	refresh_skills()

func hide_ui():
	"""Hide the skill upgrade UI"""
	if panel:
		panel.visible = false

func set_character_data(char_data: CharacterData):
	"""Set character data and refresh display"""
	character_data = char_data
	if is_visible_ui:
		refresh_skills()

func refresh_skills():
	"""Refresh the skill list display"""
	if not skills_container or not character_data:
		return
	
	# Clear existing skills
	for child in skills_container.get_children():
		child.queue_free()
	
	# Add title
	var title = Label.new()
	title.text = "Skill Upgrades"
	title.add_theme_font_size_override("font_size", 20)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	skills_container.add_child(title)
	
	# Add each skill
	for i in range(character_data.skills.size()):
		var skill = character_data.skills[i]
		var skill_panel = create_skill_panel(skill, i)
		skills_container.add_child(skill_panel)
	
	# Add close button
	var close_btn = Button.new()
	close_btn.text = "Close (PageUp)"
	close_btn.pressed.connect(hide_ui)
	skills_container.add_child(close_btn)

func create_skill_panel(skill: Skill, index: int) -> Panel:
	"""Create a panel for a single skill"""
	var panel_node = Panel.new()
	panel_node.custom_minimum_size = Vector2(0, 100)
	
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_bottom", 10)
	panel_node.add_child(margin)
	
	var vbox = VBoxContainer.new()
	margin.add_child(vbox)
	
	# Skill name
	var name_label = Label.new()
	name_label.text = skill.skill_name
	name_label.add_theme_font_size_override("font_size", 16)
	vbox.add_child(name_label)
	
	# Skill level
	var level_label = Label.new()
	level_label.text = "Level: %d / %d" % [skill.skill_level, skill.max_level]
	vbox.add_child(level_label)
	
	# Skill stats
	var stats_label = Label.new()
	stats_label.text = "Damage: %d | Mana: %d | Cooldown: %.1fs" % [skill.get_damage(), skill.get_mana_cost(), skill.get_cooldown()]
	vbox.add_child(stats_label)
	
	# Upgrade button
	var upgrade_btn = Button.new()
	if skill.can_upgrade():
		upgrade_btn.text = "Upgrade (Level %d → %d)" % [skill.skill_level, skill.skill_level + 1]
		upgrade_btn.pressed.connect(_on_upgrade_skill.bind(index))
	else:
		upgrade_btn.text = "Max Level"
		upgrade_btn.disabled = true
	vbox.add_child(upgrade_btn)
	
	return panel_node

func _on_upgrade_skill(skill_index: int):
	"""Handle skill upgrade button press"""
	if not character_data or skill_index >= character_data.skills.size():
		return
	
	var skill = character_data.skills[skill_index]
	if skill.upgrade():
		print("Upgraded %s to level %d" % [skill.skill_name, skill.skill_level])
		refresh_skills()
		skill_upgraded.emit(skill_index)
