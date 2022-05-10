class_name Player
extends KinematicBody2D

signal respawn
signal update_xp(new_value, new_max)
signal update_health(new_value)
signal enemy_dead(enemy_name)

const SPEED := 250.0
const TIME_TO_TELEPORT := 1.0

var _time_teleport_key_held := 0.0
var _damage := 1
var _health := 0
var _experience := 0
var _level_threshold := 100
var _max_health := 10

onready var _sprite = $Sprite as AnimatedSprite


func _ready()->void:
	_health = _max_health


func _physics_process(delta:float)->void:
	var direction := Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
	
	if direction != Vector2.ZERO:
		_sprite.play("running")
	else:
		_sprite.play("stationary")
	
	# warning-ignore:return_value_discarded
	move_and_collide(direction * SPEED * delta)
	
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("shoot"):
		_shoot()
	
	if Input.is_action_pressed("teleport"):
		_time_teleport_key_held += delta
		if _time_teleport_key_held >= TIME_TO_TELEPORT:
			_time_teleport_key_held = 0.0
			emit_signal("respawn")


func _shoot()->void:
	var bullet = load("res://Player/PlayerBullet.tscn").instance()
	bullet.position = global_position
	bullet.angle = rotation
	bullet.damage = _damage
	get_parent().add_child(bullet)




func _on_EnemyDetectionZone_body_entered(body:PhysicsBody2D)->void:
	if body is Enemy:
		body.activate(self)


func hit(damage_done:int)->void:
	_health -= damage_done
	emit_signal("update_health", _health)


func slew_enemy(enemy_type:String)->void:
	match enemy_type:
		"melee":
			_experience += 2
		"ranged":
			_experience += 3
		"turret":
			_experience += 1
	
	if _experience >= _level_threshold:
		_level()
	
	emit_signal("update_xp", _experience, _level_threshold)
	emit_signal("enemy_dead", enemy_type)


func _level()->void:
	_experience -= _level_threshold
	_level_threshold *= 2
	_max_health += 10
	_health = _max_health
	emit_signal("update_health", _health)
