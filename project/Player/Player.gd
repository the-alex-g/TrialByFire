class_name Player
extends KinematicBody2D

signal respawn

const SPEED := 250.0
const TIME_TO_TELEPORT := 1.0

var _time_teleport_key_held := 0.0
var _damage := 1
var _health := 0


func _physics_process(delta:float)->void:
	var direction := Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
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


func _draw()->void:
	draw_circle(Vector2.ZERO, 10, Color.red)


func _on_EnemyDetectionZone_body_entered(body:PhysicsBody2D)->void:
	if body is Enemy:
		body.activate(self)


func hit(damage_done:int)->void:
	_health -= damage_done
