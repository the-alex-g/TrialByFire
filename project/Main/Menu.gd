extends Control

const CONFIG_PATH := "user://settings.cfg"

onready var _stat_container = $Stats as VBoxContainer
onready var _button_container = $Buttons as VBoxContainer
onready var _turrets_slain_label = $Stats/Turrets as Label
onready var _ranged_slain_label = $Stats/Ranged as Label
onready var _melee_slain_label = $Stats/Melee as Label


func _ready()->void:
	var config := ConfigFile.new()
	var error := config.load(CONFIG_PATH)
	if error == OK:
		_turrets_slain_label.text = "Turrets Slain: " + str(config.get_value("defeated_enemies", "turret", 0))
		_ranged_slain_label.text = "Ranged Enemies Slain: " + str(config.get_value("defeated_enemies", "ranged", 0))
		_melee_slain_label.text = "Melee Enemies Slain: " + str(config.get_value("defeated_enemies", "melee", 0))


func _on_StatButton_pressed()->void:
	_stat_container.show()
	_button_container.hide()


func _on_Back_pressed()->void:
	_stat_container.hide()
	_button_container.show()


func _on_Play_pressed()->void:
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Main/Main.tscn")


func _on_Reset_pressed()->void:
	var confirmation := ConfirmationDialog.new()
	add_child(confirmation)
	confirmation.show()
	confirmation.dialog_text = "Are you sure you want to reset the stats?"
	# warning-ignore:return_value_discarded
	confirmation.get_ok().connect("pressed", self, "reset")


func reset()->void:
	var config := ConfigFile.new()
	var error := config.load(CONFIG_PATH)
	if error == OK:
		config.set_value("defeated_enemies", "turret", 0)
		config.set_value("defeated_enemies", "ranged", 0)
		config.set_value("defeated_enemies", "melee", 0)
		
		_turrets_slain_label.text = "Turrets Slain: 0"
		_ranged_slain_label.text = "Ranged Enemies Slain: 0"
		_melee_slain_label.text = "Melee Enemies Slain: 0"
		
		# warning-ignore:return_value_discarded
		config.save(CONFIG_PATH)
