extends Node

var curses = ["Blood Dash", "Shadow Blade", "Ghost Shield", "Soul Bomb"]

func apply_random_curse(player: Node2D):
	var curse = curses[randi() % curses.size()]
	print("Player cursed with: ", curse)
	
	# 1. Reset to base stats first so curses don't stack infinitely
	player.current_speed = 200.0
	player.max_health = 100
	
	# 2. Apply the specific curse modifiers
	if curse == "Blood Dash":
		player.current_speed = 280.0
		player.max_health = 75
	elif curse == "Ghost Shield":
		player.current_speed = 150.0
		# Add invulnerability logic later
	elif curse == "Shadow Blade":
		# Add damage buff later
		pass
		
	# 3. Heal to full new max health
	player.current_health = player.max_health
