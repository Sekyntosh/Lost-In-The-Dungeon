extends Node2D

@export var source_id = 2
@export var scenes_id = 0
@export var player_spawn_point: PackedScene = preload("res://Objects/PlayerStart/player_start.tscn")

@export var top_left_corner_tile: Vector2i = Vector2i(0, 0)
@export var top_right_corner_tile: Vector2i = Vector2i(5, 0)
@export var bottom_left_corner_tile: Vector2i = Vector2i(0, 4)
@export var bottom_right_corner_tile: Vector2i = Vector2i(5, 4)
@export var corridor_tile_horizontal_top: Vector2i = Vector2i(1, 0)
@export var corridor_tile_horizontal_bottom: Vector2i = Vector2i(1, 4)
@export var corridor_tile_vertical_left: Vector2i = Vector2i(0, 3)
@export var corridor_tile_vertical_right: Vector2i = Vector2i(5, 3)



## Each logical grid cell is painted as a PAINT_SCALE x PAINT_SCALE tile block.
const PAINT_SCALE: int = 2

var grid = []

var map_size = Vector2i.ZERO
## Room cell where the backtracker started (useful for player spawn later).
var start_cell: Vector2i = Vector2i.ZERO
@export var stage: int = 1

func _ready() -> void:
	add_to_group("maze")
	build_room()
	fit_camera_to_room()
	set_player_spawn_point()


func tile_size() -> Vector2:
	return Vector2($LaberinthBody.tile_set.tile_size)


func is_floor(cell: Vector2i) -> bool:
	if cell.y < 0 or cell.y >= grid.size():
		return false
	if cell.x < 0 or cell.x >= grid[cell.y].size():
		return false
	return grid[cell.y][cell.x] == 0


func _floor_neighbor_dirs(cell: Vector2i) -> Array[Vector2i]:
	var dirs: Array[Vector2i] = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
	var result: Array[Vector2i] = []
	for dir in dirs:
		if is_floor(cell + dir):
			result.append(dir)
	return result


## Junction, corner, or dead end — places where Conduction slides stop.
func is_node(cell: Vector2i) -> bool:
	if not is_floor(cell):
		return false
	var neighbors := _floor_neighbor_dirs(cell)
	if neighbors.size() != 2:
		return true
	# Two neighbors that are not opposite => corner.
	return neighbors[0] + neighbors[1] != Vector2i.ZERO


func _logical_cell_size() -> Vector2:
	return tile_size() * float(PAINT_SCALE)


func cell_to_world(cell: Vector2i) -> Vector2:
	var block := _logical_cell_size()
	return to_global(Vector2(cell) * block + block * 0.5)


func world_to_cell(pos: Vector2) -> Vector2i:
	var local := to_local(pos)
	var block := _logical_cell_size()
	return Vector2i(floori(local.x / block.x), floori(local.y / block.y))

func make_grid(width: int, height: int, fill_value: int) -> Array:
	var grid: Array = []
	for y in height:
		var row: Array = []
		for x in width:
			row.append(fill_value)
		grid.append(row)
	return grid
	
func build_room() -> void:
	# Base 21 so stage 1 is already a real maze; +2 per stage keeps size odd.
	var laberinth_size := 21 + (stage - 1) * 2
	if laberinth_size % 2 == 0:
		laberinth_size += 1
	grid = make_grid(laberinth_size, laberinth_size, 1)
	carve_maze()
	convert_grid_to_tiles()


func convert_grid_to_tiles() -> void:
	$LaberinthBody.clear()
	for y in grid.size():
		for x in grid[y].size():
			var base := Vector2i(x, y) * PAINT_SCALE
			for oy in PAINT_SCALE:
				for ox in PAINT_SCALE:
					var paint_cell := base + Vector2i(ox, oy)
					if grid[y][x] == 1:
						$LaberinthBody.set_cell(paint_cell, source_id, simple_wall)
					else:
						$LaberinthBody.erase_cell(paint_cell)


## Recursive-backtracker
## grid: 1 = wall, 0 = floor.
func carve_maze() -> void:
	var height: int = grid.size()
	if height == 0:
		return
	var width: int = grid[0].size()
	if width < 3 or height < 3:
		return

	var directions: Array[Vector2i] = [
		Vector2i(0, -2),
		Vector2i(0, 2),
		Vector2i(-2, 0),
		Vector2i(2, 0),
	]

	# Odd coords only (room cells). Four corners = random "side" to start from.
	var corners: Array[Vector2i] = [
		Vector2i(1, 1),
		Vector2i(width - 2, 1),
		Vector2i(1, height - 2),
		Vector2i(width - 2, height - 2),
	]
	start_cell = corners[randi() % corners.size()]
	grid[start_cell.y][start_cell.x] = 0
	var stack: Array[Vector2i] = [start_cell]

	while not stack.is_empty():
		var current: Vector2i = stack[stack.size() - 1]
		var options: Array[Vector2i] = []

		for dir in directions:
			var next: Vector2i = current + dir
			if next.x <= 0 or next.y <= 0 or next.x >= width - 1 or next.y >= height - 1:
				continue
			if grid[next.y][next.x] == 1:
				options.append(next)

		if options.is_empty():
			stack.pop_back()
			continue

		var chosen: Vector2i = options[randi() % options.size()]
		var between: Vector2i = current + (chosen - current) / 2
		grid[between.y][between.x] = 0
		grid[chosen.y][chosen.x] = 0
		stack.append(chosen)


func fit_camera_to_room() -> void:
	var camera: Camera2D = $Camera2D
	var used_space = $LaberinthBody.get_used_rect()
	var tile_size = $LaberinthBody.tile_set.tile_size
	var size_px := Vector2(used_space.size) * Vector2(tile_size)
	var view := get_viewport().get_visible_rect().size
	var z := minf(view.x / size_px.x, view.y / size_px.y) * 0.9
	camera.zoom = Vector2(z, z)

	camera.position = size_px * 0.5


func set_player_spawn_point() -> void:
	var player_spawn_point_instance: Marker2D = player_spawn_point.instantiate()
	add_child(player_spawn_point_instance)
	player_spawn_point_instance.global_position = cell_to_world(start_cell)
	player_spawn_point_instance.spawn_player()
