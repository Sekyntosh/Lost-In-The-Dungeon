extends Node

var player_stage: int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func level_end() -> void:
	player_stage += 1
	var maze := get_tree().get_first_node_in_group("maze")
	if maze == null:
		push_error("RunManager: no maze in tree.")
		return
	maze.stage = player_stage
	maze.build_room()
	maze.fit_camera_to_room()
	maze.set_player_spawn_point()
	maze.set_level_end()
	
	
	
	
