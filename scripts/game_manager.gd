extends Node

var blackout_timer = 0.0
var is_blackout = false

func _process(delta):
	if not multiplayer.is_server(): 
		return # Server calculates the blackout timing
		
	blackout_timer += delta
	
	# Trigger Blackout every 35 seconds
	if blackout_timer > 35.0 and not is_blackout:
		_rpc_trigger_blackout.rpc(true)
	# Turn lights back on after 10 seconds
	elif blackout_timer > 45.0 and is_blackout:
		_rpc_trigger_blackout.rpc(false)
		blackout_timer = 0.0

@rpc("authority", "call_local", "reliable")
func _rpc_trigger_blackout(active: bool):
	is_blackout = active
	var modulate = get_tree().root.get_node_or_null("Arena/CanvasModulate")
	
	if modulate:
		# Tween slowly to near-pitch-black, or back to normal daylight
		var target_color = Color(0.05, 0.05, 0.08) if active else Color(1, 1, 1)
		var tween = get_tree().create_tween()
		tween.tween_property(modulate, "color", target_color, 2.0)
