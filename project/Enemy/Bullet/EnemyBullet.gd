extends Bullet

var max_range := -1.0

onready var _life_timer = $LifeTimer as Timer


func _ready()->void:
	if max_range > 0.0:
		_life_timer.start(max_range / SPEED)


func _on_EnemyBullet_body_entered(body:PhysicsBody2D)->void:
	if body is Player:
		body.hit(damage)
	queue_free()


func _on_LifeTimer_timeout()->void:
	queue_free()
