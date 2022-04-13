extends MobileEnemy

const RANGE := 250.0
const COOLDOWN_TIME := 1.0
const BULLET := preload("res://Enemy/Bullet/EnemyBullet.tscn")

var _can_shoot := true

onready var _cooldown_timer = $ShootTimer as Timer


func _process(_delta:float)->void:
	if not _activated:
		return
	
	if _can_see_target():
		if _is_target_in_range():
			_stop_moving = true
			if _can_shoot:
				_shoot()
		else:
			_stop_moving = false
	else:
		_stop_moving = false


func _is_target_in_range()->bool:
	var difference := _target.global_position - position
	if difference.length_squared() < RANGE * RANGE:
		return true
	else:
		return false


func _shoot()->void:
	_can_shoot = false
	var _bullet = BULLET.instance()
	_bullet.position = global_position
	_bullet.angle = rotation
	_bullet.damage = damage
	_bullet.type = enemy_type
	get_parent().add_child(_bullet)
	_cooldown_timer.start(COOLDOWN_TIME + randf())


func _on_ShootTimer_timeout()->void:
	_can_shoot = true
