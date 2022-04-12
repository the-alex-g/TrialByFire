extends Bullet


func _on_EnemyBullet_body_entered(body:PhysicsBody2D)->void:
	if body is Player:
		body.hit(damage)
	queue_free()
