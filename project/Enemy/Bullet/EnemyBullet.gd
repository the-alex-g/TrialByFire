extends Bullet

var max_range := -1.0
var type = ""

onready var _life_timer = $LifeTimer as Timer
onready var _tween = $Tween as Tween
onready var _sprite = $Sprite as AnimatedSprite


func _ready()->void:
	rotation = angle
	_tween.interpolate_property(self, "scale", null, Vector2.ONE, 0.1, Tween.TRANS_QUAD)
	_tween.start()
	if max_range > 0.0:
		_life_timer.start(max_range / speed)
	_sprite.play(type)


func _on_EnemyBullet_body_entered(body:PhysicsBody2D)->void:
	if body is Player:
		body.hit(damage)
	queue_free()


func _on_LifeTimer_timeout()->void:
	queue_free()


func _on_Tween_tween_all_completed()->void:
	if type == "turret":
		$AnimationPlayer.play("pulse")
