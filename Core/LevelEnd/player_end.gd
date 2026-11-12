extends Area2D


func _ready() -> void:
	add_to_group("level_end")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		RunManager.level_end()
