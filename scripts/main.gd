extends Control

func _ready():
	# Find our buttons and connect them to functions when pressed
	$VBoxContainer/Button.pressed.connect(_on_host_pressed)
	$VBoxContainer/Button2.pressed.connect(_on_join_pressed)

func _on_host_pressed():
	Network.host_game()
	load_arena()

func _on_join_pressed():
	# For now, it just joins localhost. We will add the Cloudflare URL later.
	Network.join_game("ws://127.0.0.1:7777")
	load_arena()

func load_arena():
	# 1. Load the map
	var arena = load("res://scenes/main/Arena.tscn").instantiate()
	get_tree().root.add_child(arena)
	
	# 2. Spawn the Player dynamically
	var player_scene = load("res://scenes/player/Player.tscn")
	var player = player_scene.instantiate()
	# The player's name MUST be their network ID for multiplayer authority to work
	player.name = str(multiplayer.get_unique_id())
	arena.add_child(player)
	
	# 3. Spawn the Hunter (Only the Host is allowed to spawn enemies)
	if multiplayer.is_server():
		var hunter_scene = load("res://scenes/enemies/Hunter.tscn")
		var hunter = hunter_scene.instantiate()
		hunter.name = "Hunter"
		hunter.global_position = Vector2(800, 800) # Spawn away from the center
		arena.add_child(hunter)
		
	# 4. Hide the main menu
	queue_free()
