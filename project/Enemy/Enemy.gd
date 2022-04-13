class_name Enemy
extends KinematicBody2D

export var health := 1
export var damage := 1
export var color := Color.orange

var _activated := false
var _target : KinematicBody2D = null


func _draw()->void:
	draw_circle(Vector2.ZERO, 10, color)


func hit(damage_done:int)->void:
	health -= damage_done
	if health <= 0:
		queue_free()


func activate(player)->void:
	_activated = true
	_target = player


func _can_see_target()->bool:
	var intersection := get_world_2d().direct_space_state.intersect_ray(position, _target.global_position, [self])
	if intersection.size() > 0:
		return intersection.collider == _target
	else:
		return false
