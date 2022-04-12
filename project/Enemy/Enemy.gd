class_name Enemy
extends KinematicBody2D

var _activated := false


func _draw()->void:
	draw_circle(Vector2.ZERO, 10, Color.orange)


func hit()->void:
	queue_free()


func activate()->void:
	_activated = true
