extends Marker2D

@export var player_scene: PackedScene = preload("res://Objects/Player/player.tscn")


## Spawns the player at this node's global position.
## Returns the player instance (or null if player_scene is missing).

func spawn_player(parent: Node = null) -> Node2D:
	var existing := get_tree().get_first_node_in_group("player") as Node2D
	if existing != null:
		existing.global_position = global_position
		return existing

	if player_scene == null:
		push_error("PlayerStart: player_scene is not set.")
		return null

	var player: Node2D = player_scene.instantiate()
	player.global_position = global_position
	if parent == null:
		parent = get_tree().current_scene
	parent.add_child.call_deferred(player)
	return player
