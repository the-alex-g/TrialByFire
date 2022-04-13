extends Enemy

const ATTACK_COOLDOWN_TIME := 1.0
const SPEED := 100.0

var _player_in_range := false
var _can_attack := true
var _has_seen_target := false
var _should_move := false

onready var _cooldown_timer = $AttackTimer as Timer


func _ready()->void:
	_cooldown_timer.wait_time += randf()


func _process(delta:float)->void:
	if not _activated:
		return
	
	if _player_in_range and _can_attack:
		_attack()
	
	if _can_see_target():
		if not _has_seen_target:
			_has_seen_target = true
		_should_move = true
		
		look_at(_target.global_position)
	
	if _should_move:
		var direction := Vector2.RIGHT.rotated(rotation)
		var collision := move_and_collide(direction * SPEED * delta)
		
		if collision != null:
			_should_move = false


func _attack()->void:
	_can_attack = false
	_target.hit(damage)
	_cooldown_timer.start(ATTACK_COOLDOWN_TIME + randf())


func _on_HitArea_body_entered(body:PhysicsBody2D)->void:
	if body == _target:
		_player_in_range = true


func _on_HitArea_body_exited(body:PhysicsBody2D)->void:
	if body == _target:
		_player_in_range = false


func _on_AttackTimer_timeout()->void:
	_can_attack = true
