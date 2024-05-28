extends Button

var logo_array = [
	preload('res://assets/logo.png'),
	preload('res://assets/logo2.png'),
	preload('res://assets/logo3.png')
]

var current_logo_id = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func change_logo(direction):
	current_logo_id = wrapi(current_logo_id + direction, 0, 3)
	icon = logo_array[current_logo_id]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_left'):
		change_logo(1)
	if event.is_action_pressed('ui_right'):
		change_logo(-1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_down() -> void:
	SceneManager.change_scene('game')
	pass # Replace with function body.
