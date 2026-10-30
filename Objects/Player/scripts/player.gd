extends CharacterBody2D

@export var movement_speed: float = 160.0

var _moving: bool = false
var _maze: Node2D = null
var _buffered_dir: Vector2i = Vector2i.ZERO


func _ready() -> void:
	call_deferred("_setup")


func _setup() -> void:
	_maze = get_tree().get_first_node_in_group("maze")
	if _maze == null:
		push_error("Player: no node in group 'maze'.")
		return
	var cell: Vector2i = _maze.world_to_cell(global_position)
	global_position = _maze.cell_to_world(cell)


func _physics_process(_delta: float) -> void:
	if _maze == null:
		return

	var pressed := _read_dir_just_pressed()
	if pressed == Vector2i.ZERO:
		return

	if _moving:
		_buffered_dir = pressed
	else:
		slide(pressed)


func _read_dir_just_pressed() -> Vector2i:
	if Input.is_action_just_pressed("left"):
		return Vector2i.LEFT
	if Input.is_action_just_pressed("right"):
		return Vector2i.RIGHT
	if Input.is_action_just_pressed("up"):
		return Vector2i.UP
	if Input.is_action_just_pressed("down"):
		return Vector2i.DOWN
	return Vector2i.ZERO


func slide(dir: Vector2i) -> void:
	if _moving or _maze == null:
		return

	var cell: Vector2i = _maze.world_to_cell(global_position)
	var next: Vector2i = cell + dir
	if not _maze.is_floor(next):
		return

	var path: Array[Vector2i] = []
	var cursor := next
	while _maze.is_floor(cursor):
		path.append(cursor)
		if _maze.is_node(cursor):
			break
		cursor += dir

	if path.is_empty():
		return

	_moving = true
	_buffered_dir = Vector2i.ZERO
	var tween := create_tween()
	var from := global_position
	for step in path:
		var to: Vector2 = _maze.cell_to_world(step)
		var duration: float = from.distance_to(to) / movement_speed
		tween.tween_property(self, "global_position", to, duration)
		from = to
	await tween.finished
	_moving = false

	if _buffered_dir != Vector2i.ZERO:
		var next_dir := _buffered_dir
		_buffered_dir = Vector2i.ZERO
		slide(next_dir)
