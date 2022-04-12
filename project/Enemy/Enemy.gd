class_name Enemy
extends KinematicBody2D

export var health := 1
export var damage := 1

var _activated := false
var _target : KinematicBody2D = null


func _process(_delta:float)->void:
	if not _activated:
		return
	
	look_at(_target.global_position)


func _draw()->void:
	draw_circle(Vector2.ZERO, 10, Color.orange)


func hit(damage_done:int)->void:
	health -= damage_done
	if health <= 0:
		queue_free()


func activate(player)->void:
	_activated = true
	_target = player
