extends CharacterBody2D

@export var movement_speed = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input_dir := Input.get_vector("left","right","up","down")
	
	velocity = input_dir * movement_speed
	
	move_and_slide()
