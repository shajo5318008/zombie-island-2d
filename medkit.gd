extends Area2D

@export var heal_amount = 20

func _on_body_entered(body):
	# Only pick up if it's the Player and they aren't already at full health
	if body.name == "Player":
		if body.health < 100:
			body.take_damage(-heal_amount) # Negative damage = Healing!
			queue_free() # Remove medkit from map
