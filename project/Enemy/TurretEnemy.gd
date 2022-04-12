extends Enemy

const COOLDOWN_TIME := 1.5

var _Bullet := preload("res://Enemy/Bullet/EnemyBullet.tscn")
var _can_shoot := true

onready var _cooldown_timer = $ShootTimer as Timer


func _ready()->void:
	_cooldown_timer.wait_time += randf()


func _process(_delta:float)->void:
	if not _activated:
		return
	
	if _can_shoot:
		_shoot()


func _shoot()->void:
	_can_shoot = false
	var _bullet = _Bullet.instance()
	_bullet.position = global_position
	_bullet.angle = rotation
	_bullet.damage = damage
	get_parent().add_child(_bullet)
	_cooldown_timer.start(COOLDOWN_TIME + randf())


func _on_ShootTimer_timeout()->void:
	_can_shoot = true
