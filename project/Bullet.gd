class_name Bullet
extends Area2D

var speed := 500.0
var angle := 0.0
var damage := 0


func _process(delta:float)->void:
	position += (Vector2.RIGHT * delta * speed).rotated(angle)
