extends Node2D

var zombie_scene = preload("res://zombie.tscn")
var score = 0 # NEW: The Kill Counter

func _on_timer_timeout():
	var z = zombie_scene.instantiate()
	var random_x = randf_range(200, 800)
	var random_y = randf_range(200, 800)
	z.position = Vector2(random_x, random_y)
	add_child(z)

# NEW: The Score System
func add_score():
	score += 1
	$UI/ScoreLabel.text = "Kills: " + str(score)


func _on_restart_pressed():
	get_tree().paused = false # We MUST unpause before reloading!
	get_tree().reload_current_scene()
	
# Add this anywhere in world.gd
func game_over():
	$UI/GameOverMenu.show() # Make the menu visible
	get_tree().paused = true # Freeze the game

# This is the signal you just connected from the button
func _on_button_pressed():
	print("THE BUTTON WORKS!") # <--- NEW LINE
	get_tree().paused = false
	get_tree().reload_current_scene()
