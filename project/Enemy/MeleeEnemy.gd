extends MobileEnemy

const COOLDOWN_TIME := 1.0

var _player_in_range := false
var _can_attack := true

onready var _cooldown_timer = $AttackTimer as Timer


func _process(_delta:float)->void:
	if not _activated:
		return
	
	if _player_in_range and _can_attack:
		_attack()


func _attack()->void:
	_can_attack = false
	_target.hit(damage)
	_cooldown_timer.start(COOLDOWN_TIME + randf())


func _on_HitArea_body_entered(body:PhysicsBody2D)->void:
	if body == _target:
		_player_in_range = true


func _on_HitArea_body_exited(body:PhysicsBody2D)->void:
	if body == _target:
		_player_in_range = false


func _on_AttackTimer_timeout()->void:
	_can_attack = true
