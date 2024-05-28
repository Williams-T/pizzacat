extends Polygon2D

var total_area = 0.0
@onready var chop_area = $Area2D
@onready var chop_area_coll_polygon = $Area2D/CollisionPolygon2D

var dough_instance = load("res://scenes/game/Dough/dough.tscn")

var focused = false
var aiming = false
var mouse_pos
var click_start
var click_end
var children = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()
	pass # Replace with function body.

func _init(_polygon = polygon) -> void:
	polygon = _polygon

func setup():
	total_area = calculate_area()
	generate_chop_poly()
	print(total_area)

func calculate_area(_polygon = polygon):
	# take an irregular polygon and calculate the area
	var poly_array = _polygon
	# adjust the list of coords so that it's clockwise and the first coord is repeated at the end
	poly_array.append(poly_array[0])
	# cross multiply each coord with the next coord in the list:
	# eg: (Xn * Yn+1) - (Xn+1 * Yn)
	#     (Xn+1 * Yn+2) - (Xn+2 * Yn+1)
	var sum_of_cross_products := 0.0
	for id in poly_array.size()-2:
		var cross_prod = ( float(poly_array[id].x) * float(poly_array[id+1].y) ) - \
		( float(poly_array[id+1].x) * float(poly_array[id].y) )
		sum_of_cross_products += cross_prod
	
	# return the sum of all cross products divided by 2
	return 0.5 * (sum_of_cross_products * 0.1)

func generate_chop_poly():
	var temp_polygon := polygon
	var highest = null
	var lowest = null
	var temp_poly : PackedVector2Array = []
	for i in temp_polygon:
		temp_poly.append(Vector2(i + offset))
	
	chop_area_coll_polygon.polygon = temp_poly

func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#if (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
			#if focused and event.is_pressed():
				#click_start = get_global_mouse_position()
				##print(click_start)
			#if event.is_released():
				#click_end = get_global_mouse_position()
				##print(click_end)
	if event is InputEventMouseMotion:
		if aiming:
			
			queue_redraw()
	
	if event.is_action_pressed("l_click"):
		if focused:
			click_start = get_local_mouse_position()
			print(click_start)
			aiming = true

	if event.is_action_released("l_click"):
		if aiming:
			click_end = get_local_mouse_position()
			print(click_end)
			var slices = cut(focused)
			if slices != null:
				detach(slices)
			aiming = false
			queue_redraw()
	
	if event.is_action("r_click"):
		if aiming:
			aiming = false

func cut(_focused = false):
	if _focused:
		click_end = click_end.lerp(click_start, -10.0)
		if Geometry2D.is_point_in_polygon(click_end, polygon):
			return null
	#var line : PackedVector2Array = [click_start, click_end]
	var start_point = click_end
	var end_point = click_start + (click_start - click_end)
	var left_slice = Geometry2D.clip_polygons(polygon, PackedVector2Array(
			[start_point + Vector2(-1000,0), start_point, end_point, end_point + Vector2(-1000,0)]))
	var right_slice = Geometry2D.clip_polygons(polygon, PackedVector2Array(
			[start_point, start_point + Vector2(1000,0), end_point + Vector2(1000,0), end_point]))
	return [left_slice, right_slice]

func detach(slice_array):
	polygon = slice_array[1][0]
	setup()
	var new_dough = dough_instance.instantiate()
	new_dough._init(slice_array[0][0])
	add_child(new_dough)
	new_dough.position -= offset
	#new_dough.offset = offset
	#position.y -= 10
	
	

func _on_area_2d_mouse_entered() -> void:
	focused = true
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	focused = false
	pass # Replace with function body.

func _draw() -> void:
	if aiming:
		var mp = get_local_mouse_position()
		draw_line(mp, click_start + (click_start - mp), Color.DEEP_SKY_BLUE, 3.0, true)
