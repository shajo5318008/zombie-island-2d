extends CharacterBody2D
@export var speed = 80
var player = null
var health = 2 
var blood_scene = preload("res://blood_particles.tscn")
var knockback = Vector2.ZERO 

# NEW: The Pathfinding Optimization Variables
var path_timer = 0.0
var path_delay = 0.2 # 0.2 seconds means it updates 5 times a second instead of 60!

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	if player != null:
		# --- THE OPTIMIZATION ---
		# Subtract the frame time from our timer
		path_timer -= delta 
		
		# Only ask for a new GPS route if the timer hits zero
		if path_timer <= 0.0:
			$NavigationAgent2D.target_position = player.global_position
			path_timer = path_delay # Reset the timer back to 0.2
		# ------------------------
		
		# Get the next step and move (This is lightweight, so doing it 60fps is fine!)
		var next_path_position = $NavigationAgent2D.get_next_path_position()
		var direction = global_position.direction_to(next_path_position)
		look_at(next_path_position) 
		
		velocity = (direction * speed) + knockback 
		knockback = knockback.lerp(Vector2.ZERO, 10 * delta) 
		
		move_and_slide()
		
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			
			if collider != null and collider.name == "Player":
				collider.take_damage(10) 
				queue_free()

func take_damage():
	health -= 1
	if player != null:
		var push_dir = player.global_position.direction_to(global_position)
		knockback = push_dir * 600 
		
	if health <= 0:
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
