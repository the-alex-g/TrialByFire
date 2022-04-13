extends Enemy

const COOLDOWN_TIME := 1.5
const BULLET := preload("res://Enemy/Bullet/EnemyBullet.tscn")

var _can_shoot := true

onready var _cooldown_timer = $ShootTimer as Timer


func _process(_delta:float)->void:
	if not _activated:
		return
	
	look_at(_target.global_position)
	
	if _can_shoot and _can_see_target():
		_shoot()


func _shoot()->void:
	_can_shoot = false
	var _bullet = BULLET.instance()
	_bullet.position = global_position
	_bullet.angle = rotation
	_bullet.damage = damage
	_bullet.type = enemy_type
	_bullet.speed = 200
	get_parent().add_child(_bullet)
	_cooldown_timer.start(COOLDOWN_TIME + randf())


func _on_ShootTimer_timeout()->void:
	_can_shoot = true
