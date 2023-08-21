class_name Player
extends CharacterBody2D

@export var SPEED = 150
@onready var animation_tree : AnimationTree = $AnimationTree # same as get_node("AnimationTree")
@onready var attack_hold_timer : Timer = $AnimationTree/AttackHoldTimer
@onready var attack_release_timer : Timer = $AnimationTree/AttackReleaseTimer
@onready var attack_cooldown_timer : Timer = $AnimationTree/AttackCooldownTimer
var direction : Vector2 = Vector2.ZERO
var can_attack = true

func _ready():
	animation_tree.active = true
	animation_tree["parameters/conditions/attack_hold_timeout"] = false
	animation_tree["parameters/conditions/attack_release_timeout"] = false


func _process(_delta):
	update_animation_parameters()
	

func _physics_process(_delta):
	
	direction = get_input_direction()
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func get_input_direction() -> Vector2:
	return Input.get_vector("left", "right", "up", "down").normalized()
	
func update_animation_parameters():
	
	var state_machine = $AnimationTree.get("parameters/playback")
	if state_machine.get_current_node() != "Attack_Hold":
		animation_tree["parameters/conditions/attack_hold_timeout"] = false
	if state_machine.get_current_node() != "Attack_Release":
		animation_tree["parameters/conditions/attack_release_timeout"] = false
	
	var is_idle := velocity == Vector2.ZERO
	animation_tree["parameters/conditions/idle"] = is_idle
	animation_tree["parameters/conditions/is_moving"] = not is_idle
	
	# attack
	if Input.is_action_pressed("attack") and can_attack:
		animation_tree["parameters/conditions/attack"] = true
		attack_hold_timer.start()
		can_attack = false
	else:
		animation_tree["parameters/conditions/attack"] = false
	
	if direction != Vector2.ZERO:
		animation_tree["parameters/Idle/blend_position"] = direction
		animation_tree["parameters/Attack_Hold/blend_position"] = direction
		animation_tree["parameters/Attack_Release/blend_position"] = direction
		animation_tree["parameters/Walk/blend_position"] = direction


func _on_attack_hold_timer_timeout():
	animation_tree["parameters/conditions/attack_hold_timeout"] = true
	attack_release_timer.start()

func _on_attack_release_timer_timeout():
	animation_tree["parameters/conditions/attack_release_timeout"] = true
	attack_cooldown_timer.start()

func _on_attack_cooldown_timer_timeout():
	can_attack = true
