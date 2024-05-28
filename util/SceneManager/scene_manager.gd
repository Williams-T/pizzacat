extends Control

@onready var fade = $Fade
@onready var player = $AnimationPlayer
@onready var scene_container = $SceneContainer

var scenes = {
	"prod" : preload("res://scenes/title/ProdCredit.tscn"),
	"logo" : preload("res://scenes/title/title.tscn"),
	"game" : preload("res://scenes/game/game.tscn")
}

var faded = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if faded:
		player.play_backwards("fade_animation")
		faded = false
	pass # Replace with function body.

func change_scene(scene_string : String):
	if scene_string not in scenes.keys():
		print("not valid scene key")
		return false
	if faded == false:
		player.play("fade_animation")
		faded = true
		await player.animation_finished
	var num_children = scene_container.get_child_count()
	if num_children > 0:
		scene_container.get_child(0).queue_free()
	var new_scene = (scenes[scene_string] as PackedScene).instantiate()
	scene_container.add_child(new_scene)
	player.play_backwards("fade_animation")
	
	return true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
