extends CharacterBody2D

@export var speed = 80 # Kept your slower, creepier speed!
var player = null
var health = 2 

var blood_scene = preload("res://blood_particles.tscn")

# NEW: The Knockback Memory
var knockback = Vector2.ZERO 

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	if player != null:
		look_at(player.global_position)
		var direction = global_position.direction_to(player.global_position)
		
		# Combine their normal walking speed WITH the knockback force
		velocity = (direction * speed) + knockback 
		
		# Slowly fade the knockback back to zero so they can recover and chase you again
		knockback = knockback.lerp(Vector2.ZERO, 10 * delta) 
		
		move_and_slide()
		
		# The Kamikaze Bite!
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			
			if collider != null and collider.name == "Player":
				collider.take_damage(10) # The nerfed 10 damage bite
				queue_free()

# --- COMBAT CODE ---
func take_damage():
	health -= 1
	
	# NEW: Apply the physical push backwards!
	if player != null:
		var push_dir = player.global_position.direction_to(global_position)
		knockback = push_dir * 600 # Change this 600 to make the gun punch harder/softer!
		
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
		
		get_parent().add_score()
		queue_free()
