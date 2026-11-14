extends CharacterBody2D

const SPEED = 110.0
var target_player: Node2D = null

func _ready() -> void:
	add_to_group("enemies")

func _physics_process(_delta: float) -> void:
	# 1. AI only runs on the server
	if not multiplayer.is_server():
		return
		
	# 2. Find and chase the player
	_find_lowest_hp_target()
	
	if target_player != null and is_instance_valid(target_player):
		var direction = global_position.direction_to(target_player.global_position)
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()
	
	# 3. Combat: Damage and Bounce Back
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider and collider.is_in_group("players"):
			collider.take_damage.rpc(25) # Hurt the player
			# Bounce the monster backward
			var bounce_direction = -global_position.direction_to(collider.global_position)
			global_position += bounce_direction * 150 

func _find_lowest_hp_target() -> void:
	var players = get_tree().get_nodes_in_group("players")
	var lowest_hp = 9999
	var weakest_player = null
	
	for p in players:
		if p.current_health > 0 and p.current_health < lowest_hp:
			lowest_hp = p.current_health
			weakest_player = p
			
	target_player = weakest_player
