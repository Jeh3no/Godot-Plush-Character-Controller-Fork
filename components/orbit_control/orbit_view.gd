extends SpringArm3D

var active : bool = true : set = set_active

@export_group("Camera variables")
@export_range(0.0, 0.1, 0.0001) var mouseSens : float
@export_range(-90.0, 90.0, 0.1, "radians") var min_limit_x : float
@export_range(-90.0, 90.0, 0.1, "radians") var max_limit_x : float
@export_range(0.0, 20.0, 0.01) var pan_rotation_val : float

@export_group("Zoom variables")
var zoom_val : float = 8.0
@export var max_zoom_val : float
@export var min_zoom_val : float
@export var zoom_speed : float

@export_group("Keybinding variables")
@export var mouse_mode_action : String = ""
@export var cam_zoom_in_action : String = ""
@export var cam_zoom_out_action : String = ""

#references variables
@onready var cam : Camera3D = %Camera3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Input.set_use_accumulated_input(false)
	set_active(active)
	
func set_active(state : bool):
	active = state
	set_process_input(active)
	set_process(active)

func _input(event):
	if event.is_action_pressed(mouse_mode_action):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED: 
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE: 
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED: return
	
	if event is InputEventMouseMotion: 
		var viewport_transform: Transform2D = get_tree().root.get_final_transform()
		var mouse_motion = event.xformed_by(viewport_transform).relative
		rotate_from_vector(mouse_motion * mouseSens)
		
func _process(delta):
	var joy_dir = Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down")
	
	cam.position = Vector3(0.0, 0.0, zoom_val)
	
	rotate_from_vector(joy_dir * Vector2(1.0, 0.5) * pan_rotation_val * delta)
	
	zoom_handling(delta)
	

func rotate_from_vector(vector : Vector2):
	if vector.length() == 0: return
	rotation.y -= vector.x
	rotation.x -= vector.y
	rotation.x = clamp(rotation.x, min_limit_x, max_limit_x)
	
func zoom_handling(delta : float):
	zoom_val += Input.get_axis(cam_zoom_in_action, cam_zoom_out_action) * zoom_speed * delta
	zoom_val = clamp(zoom_val, min_zoom_val, max_zoom_val)
	
	
