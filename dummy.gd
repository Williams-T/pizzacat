extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneManager.change_scene('prod')
	queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
