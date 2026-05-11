extends Node2D
var medkit_scene = preload("res://medkit.tscn")
var zombie_scene = preload("res://zombie.tscn")
var score = 0 

# SETTINGS: Change this number to decide how many kills win the game!
@export var win_score = 10 

func _ready():
	$UI/ScoreLabel.text = "Kills: 0 / " + str(win_score)
	
	# 1. Start in pure Daylight (White)
	$CanvasModulate.color = Color(1.0, 1.0, 1.0) 
	
	var tween = create_tween()
	
	# Stage 1: Fade to Bright Orange Evening (takes 30 seconds)
	tween.tween_property($CanvasModulate, "color", Color(0.84, 0.47, 0.08), 30.0)
	
	# Stage 2: Fade to Deep Sunset Red (takes 30 seconds)
	tween.tween_property($CanvasModulate, "color", Color(0.4, 0.1, 0.05), 30.0)
	
	# Stage 3: Fade to Moonlight Blue (takes 30 seconds)
	tween.tween_property($CanvasModulate, "color", Color(0.279, 0.359, 0.966, 1.0), 30.0)
	
	spawn_scavenge_items(5) # Spawn 5 medkits at the start
func spawn_scavenge_items(count):
	for i in range(count):
		var item = medkit_scene.instantiate()
		
		# 1. Pick a random spot on your map (adjust numbers to fit your map size)
		var random_pos = Vector2(randf_range(100, 2000), randf_range(100, 2000))
		
		# 2. Check if the spot is valid (Optional: we can add complex checks later)
		item.position = random_pos
		add_child(item)
func _on_timer_timeout():
	var z = zombie_scene.instantiate()
	# Random spawn logic
	var random_x = randf_range(200, 800)
	var random_y = randf_range(200, 800)
	z.position = Vector2(random_x, random_y)
	add_child(z)

# The Score System
func add_score():
	score += 1
	$UI/ScoreLabel.text = "Kills: " + str(score) + " / " + str(win_score)
	
	# Check if the player has won
	if score >= win_score:
		win_game()

# --- THE WIN/LOSS LOGIC ---

func game_over():
	# This runs when the player gets bitten
	$UI/GameOverMenu/Label.text = "GAME OVER"
	$UI/GameOverMenu/Label.modulate = Color(1, 0, 0) # Red for death
	$UI/GameOverMenu.show() 
	get_tree().paused = true 

func win_game():
	# This runs when the player hits the kill goal
	$UI/GameOverMenu/Label.text = "YOU SURVIVED!"
	$UI/GameOverMenu/Label.modulate = Color(0, 1, 0) # Green for victory
	$UI/GameOverMenu.show()
	get_tree().paused = true

# --- THE RESTART BUTTON ---

func _on_restart_pressed():
	# This function handles the click for both Win and Loss screens!
	print("RESTARTING GAME...") 
	get_tree().paused = false 
	get_tree().reload_current_scene()
