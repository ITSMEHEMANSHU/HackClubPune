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
	# Hide the menu and load the map
	var arena = load("res://scenes/main/Arena.tscn").instantiate()
	get_tree().root.add_child(arena)
	queue_free() # Deletes the main menu
