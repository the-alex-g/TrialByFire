class_name Bullet
extends Area2D

const SPEED := 500.0

var angle := 0.0
var damage := 0


func _process(delta:float)->void:
	position += (Vector2.RIGHT * delta * SPEED).rotated(angle)


func _draw()->void:
	draw_circle(Vector2.ZERO, 5, Color.blue)
