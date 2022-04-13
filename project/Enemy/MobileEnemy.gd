class_name MobileEnemy
extends Enemy

export var speed := 100.0

var _has_seen_target := false
var _should_move := false


func _process(delta:float)->void:
	if not _activated:
		return
	
	if _can_see_target():
		if not _has_seen_target:
			_has_seen_target = true
		_should_move = true
		
		look_at(_target.global_position)
	
	if _should_move:
		var direction := Vector2.RIGHT.rotated(rotation)
		var collision := move_and_collide(direction * speed * delta)
		
		if collision != null:
			_should_move = false
