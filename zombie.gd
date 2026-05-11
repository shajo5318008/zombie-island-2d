extends CharacterBody2D

@export var speed = 150
var player = null
var health = 3  # It will take 3 bullets to drop this zombie

# NEW: Load the blood blueprint into the Zombie's memory
var blood_scene = preload("res://blood_particles.tscn")

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	if player != null:
		look_at(player.global_position)
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()
		
		# The Kamikaze Bite!
		# Loop through anything the zombie just crashed into
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			
			# If the thing we crashed into is the Player...
			if collider != null and collider.name == "Player":
				collider.take_damage(20) # Bite them!
				queue_free() # The zombie explodes on impact

# --- COMBAT CODE ---
func take_damage():
	health -= 1
	if health <= 0:
		# --- THE ULTIMATE BLOOD CODE ---
		var blood = blood_scene.instantiate()
		blood.position = global_position 
		get_parent().add_child(blood) 
		
		blood.amount = 30
		blood.explosiveness = 0.9 
		blood.one_shot = true
		blood.direction = Vector2(1, 0)
		blood.spread = 180.0
		blood.gravity = Vector2(0, 0) 
		blood.initial_velocity_min = 150.0
		blood.initial_velocity_max = 300.0
		blood.scale_amount_min = 3.0 
		blood.scale_amount_max = 6.0
		blood.color = Color(0.8, 0, 0) 
		
		blood.emitting = true 
		
		# --- THE MISSING SCORE & DEATH CODE ---
		get_parent().add_score() # Increase the kill counter!
		queue_free() # Actually delete the zombie from the game!
