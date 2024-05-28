extends Button

var timer_delta = 3.0
var st_ready = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

#func change_logo(direction):
	#current_logo_id = wrapi(current_logo_id + direction, 0, 3)
	#icon = logo_array[current_logo_id]

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed('ui_left'):
		#change_logo(1)
	#if event.is_action_pressed('ui_right'):
		#change_logo(-1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer_delta > 0.0:
		timer_delta -= delta
	else:
		next()
	pass

func next():
	if st_ready:
		SceneManager.faded = false
		st_ready = false
		SceneManager.change_scene('logo')

func _on_button_down() -> void:
	next()
	pass # Replace with function body.
