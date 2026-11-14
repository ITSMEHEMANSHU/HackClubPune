extends CharacterBody2D

var current_speed = 200.0
var max_health = 100
@export var current_health = 100

var run_history : Array[Vector2] = []
var record_timer = 0.0

func _ready():
	add_to_group("players")

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _physics_process(delta):
	if not is_multiplayer_authority():
		return
		
	# 1. Movement
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_dir * current_speed
	move_and_slide()
	
	# 2. Record path every 0.1 seconds for the Ghost Echo
	record_timer += delta
	if record_timer >= 0.1:
		run_history.append(global_position)
		record_timer = 0.0

@rpc("any_peer", "call_local", "reliable")
func take_damage(amount: int):
	if not is_multiplayer_authority(): return
	
	current_health -= amount
	if current_health <= 0:
		die()

func die():
	# Tell the server to spawn a ghost using our recorded path
	_rpc_spawn_ghost.rpc_id(1, run_history)
	
	# Apply curse, reset history, and respawn
	UpgradeManager.apply_random_curse(self)
	global_position = Vector2(0, 0) # Change this to a random spawn point later
	run_history.clear()

@rpc("any_peer", "call_local", "reliable")
func _rpc_spawn_ghost(history: Array):
	if multiplayer.is_server():
		var ghost_scene = load("res://scenes/player/GhostEcho.tscn")
		var ghost = ghost_scene.instantiate()
		ghost.set_path(history)
		get_tree().root.get_node("Arena").add_child(ghost)
