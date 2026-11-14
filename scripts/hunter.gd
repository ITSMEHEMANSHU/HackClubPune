extends CharacterBody2D

const SPEED = 120.0
var target_player: Node2D = null

func _ready() -> void:
	# Add the monster to a group so the GameManager can easily find it
	add_to_group("enemies")

func _physics_process(_delta: float) -> void:
	# Only the Host (Server) is allowed to control the monster's AI
	if not multiplayer.is_server():
		return
		
	_find_lowest_hp_target()
	
	if target_player != null and is_instance_valid(target_player):
		var direction = global_position.direction_to(target_player.global_position)
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()

# AI Logic: Scan all players and target the weakest one
func _find_lowest_hp_target() -> void:
	var players = get_tree().get_nodes_in_group("players")
	var lowest_hp = 9999
	var weakest_player = null
	
	for p in players:
		# Assuming your player script has a 'current_health' variable
		if p.current_health > 0 and p.current_health < lowest_hp:
			lowest_hp = p.current_health
			weakest_player = p
			
	target_player = weakest_player
