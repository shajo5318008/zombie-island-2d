extends Node2D

var zombie_scene = preload("res://zombie.tscn")
var score = 0 

# SETTINGS: Change this number to decide how many kills win the game!
@export var win_score = 10 

func _ready():
	$UI/ScoreLabel.text = "Kills: 0 / " + str(win_score)
	
	# THE FIX: Start at the Dusty Twilight Pink/Orange so the river doesn't turn green!
	$CanvasModulate.color = Color(0.85, 0.55, 0.50) 
	
	# Create the Tween
	var tween = create_tween()
	
	# Chain the colors together (22.5 seconds each, totaling 90s)
	
	# Stage 1: Fade to Deep Orange
	tween.tween_property($CanvasModulate, "color", Color(0.84, 0.47, 0.08), 22.5)
	
	# Stage 2: Fade to Rust Red
	tween.tween_property($CanvasModulate, "color", Color(0.63, 0.16, 0.06), 22.5)
	
	# Stage 3: Fade to Dark Maroon
	tween.tween_property($CanvasModulate, "color", Color(0.35, 0.04, 0.02), 22.5)
	
	# Stage 4: Fade to Moonlight Goal (Dark Blue)
	tween.tween_property($CanvasModulate, "color", Color(0.05, 0.05, 0.08), 22.5)

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
