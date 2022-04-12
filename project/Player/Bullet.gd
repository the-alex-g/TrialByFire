extends Area2D

const SPEED := 500.0


func _process(delta:float)->void:
	position += (Vector2.RIGHT * delta * SPEED).rotated(rotation)


func _draw()->void:
	draw_circle(Vector2.ZERO, 5, Color.blue)


func _on_Bullet_body_entered(body:PhysicsBody2D)->void:
	if body is Enemy:
		body.hit()
	queue_free()
