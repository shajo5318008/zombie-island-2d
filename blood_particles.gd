extends CPUParticles2D

func _ready():
	# Wait for 1 second, then permanently turn off particle simulation
	# This keeps the pixels visible on the ground without wasting performance
	await get_tree().create_timer(1.0).timeout
	emitting = false
	set_process(false) 
	set_physics_process(false)
