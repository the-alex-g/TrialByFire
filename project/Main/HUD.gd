extends CanvasLayer

onready var _healthbar = $VBoxContainer/Health as ProgressBar
onready var _xp_bar = $VBoxContainer/Experience as ProgressBar

var health_updated_previously := false


func _on_Player_update_health(new_value:int)->void:
	# the first time health is set, update the maximum value
	if not health_updated_previously:
		_healthbar.max_value = new_value
		health_updated_previously = true
	
	if new_value > _healthbar.max_value:
		_healthbar.max_value = new_value
	_healthbar.value = new_value


func _on_Player_update_xp(new_value:int, new_max:int)->void:
	_xp_bar.value = new_value
	if new_max != _xp_bar.max_value:
		_xp_bar.max_value = new_max
