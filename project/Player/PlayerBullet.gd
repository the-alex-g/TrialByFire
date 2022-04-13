extends Bullet


func _on_Bullet_body_entered(body:PhysicsBody2D)->void:
	if body is Enemy:
		body.hit(damage)
	queue_free()


func _draw()->void:
	draw_circle(Vector2.ZERO, 4, Color.red)
