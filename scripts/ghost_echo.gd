extends Area2D

var path : Array = []
var current_index = 0
var move_timer = 0.0

func set_path(history: Array):
	path = history
	if path.size() > 0:
		global_position = path[0]

func _physics_process(delta):
	# Only the server moves the ghosts; clients just sync/see them
	if not multiplayer.is_server() or path.size() == 0:
		return
		
	move_timer += delta
	if move_timer >= 0.1:
		current_index += 1
		if current_index >= path.size():
			current_index = 0 # Loop the path continuously
		global_position = path[current_index]
		move_timer = 0.0

func _on_body_entered(body):
	if multiplayer.is_server() and body.is_in_group("players"):
		body.take_damage.rpc(15) # Ghost hurts living players
