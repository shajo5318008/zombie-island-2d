extends CharacterBody2D

@export var speed = 400
var bullet_scene = preload("res://bullet.tscn")

# NEW: How violent the camera shakes
var shake_strength = 0.0 
# Add this near the top with your other variables:
var health = 100 

func _physics_process(_delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	move_and_slide()
	
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("shoot"):
		shoot()

# NEW: The Camera Shake Engine
func _process(delta):
	if shake_strength > 0:
		# Slowly fade the shake back to zero
		shake_strength = lerpf(shake_strength, 0, 10 * delta)
		# Violently jerk the camera lens around
		$Camera2D.offset = Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))

func shoot():
	# NEW: Trigger the shake!
	shake_strength = 15.0 
	
	var b = bullet_scene.instantiate()
	get_parent().add_child(b)
	b.global_transform = $Muzzle.global_transform



# Add this entirely new function at the very bottom of the script:
func take_damage(amount):
	health -= amount
	get_parent().get_node("UI/HealthLabel").text = "Health: " + str(health)
	
	if health <= 0:
		get_parent().game_over() # NEW: Tell the World we died!
	
	if health <= 0:
		print("YOU DIED!")
		get_tree().paused = true # This instantly freezes the entire game!
