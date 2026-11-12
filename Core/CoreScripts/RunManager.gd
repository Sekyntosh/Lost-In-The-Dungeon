extends Node

var player_stage: int = 1
var _transitioning: bool = false

var _loading_count: int = 0
var is_world_loading: bool = false

signal world_loading_started
signal world_loading_finished


func level_end() -> void:
	_prepare_new_world()
	
	
	
func _prepare_new_world() -> void:
	if _transitioning:
		return
	var maze := get_tree().get_first_node_in_group("maze")
	if maze == null:
		push_error("RunManager: no maze in tree.")
		return
	_transitioning = true
	signal_begin_world_loading()
	player_stage += 1
	maze.stage = player_stage
	maze.build_room()
	maze.fit_camera_to_room()
	maze.set_player_spawn_point()
	maze.set_level_end() 
	call_deferred("_finish_transition")
	
func _finish_transition() -> void:
	_transitioning = false	
	signal_end_world_loading()
	


func signal_begin_world_loading() -> void:
	_loading_count += 1
	if _loading_count == 1:
		is_world_loading = true
		world_loading_started.emit()

func signal_end_world_loading() -> void:
	_loading_count = max(_loading_count - 1, 0)
	if _loading_count == 0:
		is_world_loading = false
		world_loading_finished.emit()
