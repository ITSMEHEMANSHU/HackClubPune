extends Node

var peer = WebSocketMultiplayerPeer.new()
var is_host = false

# Call this from your Main menu UI later
func host_game(port: int = 7777):
	is_host = true
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_peer_connected)
	_spawn_player(1) # Spawn the host

# Call this to join via the Cloudflare wss:// URL
func join_game(wss_url: String):
	peer.create_client(wss_url)
	multiplayer.multiplayer_peer = peer

func _on_peer_connected(id: int):
	print("Player connected: ", id)
	_spawn_player(id)

func _spawn_player(id: int):
	# We will link this to Arena.tscn's MultiplayerSpawner later
	var player_scene = load("res://scenes/player/Player.tscn")
	var player = player_scene.instantiate()
	player.name = str(id) # CRITICAL: Node name must be the Peer ID for network authority
	
	# Fallback: add directly to tree if Arena isn't loaded yet
	var arena = get_tree().root.get_node_or_null("Arena")
	if arena:
		arena.add_child(player)
	else:
		get_tree().root.add_child(player)
