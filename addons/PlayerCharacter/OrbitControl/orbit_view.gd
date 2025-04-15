extends SpringArm3D

var active : bool = true : set = set_active

@export_group("Camera variables")
@export_range(0.0, 0.1, 0.0001) var mouse_sens : float
@export_range(-90.0, 90.0, 0.1, "radians") var min_limit_x : float
@export_range(-90.0, 90.0, 0.1, "radians") var max_limit_x : float
@export_range(0.0, 20.0, 0.01) var pan_rotation_val : float

@export_group("Zoom variables")
var zoom_val : float = 8.0
@export var max_zoom_val : float
@export var min_zoom_val : float
@export var zoom_speed : float

@export_group("Aim variables")
var cam_aimed : bool = false #if true, cam goes into "aim/shooter mode", above the play char shoulder
@export var aim_cam_pos : Vector3
var aim_cam_pos_side : bool = true #false = left, true = right

@export_group("Keybinding variables")
@export var mouse_mode_action : String = ""
@export var aim_cam_action : String = ""
@export var aim_cam_side_action : String = ""
@export var cam_zoom_in_action : String = ""
@export var cam_zoom_out_action : String = ""

#references variables
@onready var cam : Camera3D = %Camera3D

func _ready():
	#capture mouse cursor, and enable camera
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Input.set_use_accumulated_input(false)
	set_active(active)
	
func set_active(state : bool):
	#enable/disable play char camera
	active = state
	set_process_input(active)
	set_process(active)

func _input(event):
	#free/capture mouse cursor
	if event.is_action_pressed(mouse_mode_action):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED: 
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE: 
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
	#if mouse cursor is free, can't rotate cam
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED: return
	
	#change cam mode (default, aim)
	if event.is_action_pressed("aim_cam"):
		cam_aimed = !cam_aimed
		
	#change cam side when aimed (over left shoulder, or over right shoulder)
	if event.is_action_pressed("aim_cam_side"):
		aim_cam_pos_side = !aim_cam_pos_side
		
	#rotate cam according to the mouse
	if event is InputEventMouseMotion: 
		var viewport_transform: Transform2D = get_tree().root.get_final_transform()
		var mouse_motion = event.xformed_by(viewport_transform).relative
		rotate_from_vector(mouse_motion * mouse_sens)
		
func _process(delta):
	#get pan direction
	var joy_dir = Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down")
	
	#position the cam according to her mode (default, aim (with left or right side))
	if !cam_aimed: cam.position = Vector3(0.0, 0.0, zoom_val)
	else: cam.position = Vector3(aim_cam_pos.x if aim_cam_pos_side else -aim_cam_pos.x, aim_cam_pos.y, zoom_val)
	
	#rotate cam
	rotate_from_vector(joy_dir * Vector2(1.0, 0.5) * pan_rotation_val * delta)
	
	#handle zoom
	zoom_handling(delta)
	
func rotate_from_vector(vector : Vector2):
	#rotate cam by the vector's amount, and clamp the rotation between max up and max down values
	#(to avoid doing 360 degree turn with the cam for example)
	if vector.length() == 0: return
	rotation.y -= vector.x
	rotation.x -= vector.y
	rotation.x = clamp(rotation.x, min_limit_x, max_limit_x)
	
func zoom_handling(delta : float):
	#zoom in/out cam, and clamp zoom value between min and max zoom values
	zoom_val += Input.get_axis(cam_zoom_in_action, cam_zoom_out_action) * zoom_speed * delta
	zoom_val = clamp(zoom_val, min_zoom_val, max_zoom_val)
	
	
