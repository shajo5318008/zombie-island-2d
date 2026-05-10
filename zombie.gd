extends CharacterBody2D

@export var speed = 150
var player = null
var health = 3  # It will take 3 bullets to drop this zombie

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	if player != null:
		look_at(player.global_position)
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()
		
		# NEW: The Kamikaze Bite!
		# Loop through anything the zombie just crashed into
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			
			# If the thing we crashed into is the Player...
			if collider != null and collider.name == "Player":
				collider.take_damage(20) # Bite them!
				queue_free() # The zombie explodes on impact

# --- NEW COMBAT CODE ---
func take_damage():
	health -= 1
	if health <= 0:
		get_parent().add_score() # NEW: Tell the World we died!
		queue_free()
		
