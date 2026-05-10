extends Area2D

var speed = 1000

func _physics_process(delta):
	position += transform.x * speed * delta


func _on_body_entered(body):
	# 1. Ignore the Player
	if body.name == "Player":
		return 
		
	# 2. Check if the thing we hit is an enemy that can take damage
	if body.has_method("take_damage"):
		body.take_damage()
		
	# 3. Destroy the bullet after it hits a wall or a zombie
	queue_free()
