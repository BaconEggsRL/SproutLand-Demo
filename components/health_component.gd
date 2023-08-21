extends Node2D
class_name HealthComponent

@export var MAX_HEALTH := 10.0
@onready var health := MAX_HEALTH
signal health_depleted
	
func damage(attack: Attack):
	health -= attack.attack_damage
	if health <= 0:
		health_depleted.emit()
