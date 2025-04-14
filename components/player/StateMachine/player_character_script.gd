extends CharacterBody3D

#movement variables
var move_speed : float
var move_accel : float
var move_deccel : float
var move_dir : Vector2
var target_angle : float
var last_input_dir : Vector2
var last_frame_position : Vector3
var last_frame_velocity : Vector3
var was_on_floor : bool = false
var walk_or_run : String = "WalkState" #keep in memory if play char was walking or running before being in the air

@export_group("Walk variables")
@export var walk_speed : float
@export var walk_accel : float
@export var walk_deccel : float

@export_group("Run variables")
@export var run_speed : float
@export var run_accel : float
@export var run_deccel : float
@export var continious_run : bool = false #if true, doesn't need to keep run button on to run

@export_group("Jump variables")
@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float
@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
var has_cut_jump : bool = false
@export var jump_cut_multiplier : float
@export var jump_cooldown : float
var jump_cooldown_ref : float 
@export var nb_jumps_in_air_allowed : int 
var nb_jumps_in_air_allowed_ref : int
var jump_buff_on : bool = false
var buffered_jump : bool = false
@export var coyote_jump_cooldown : float
var coyote_jump_cooldown_ref : float
var coyote_jump_on : bool = false
@export var auto_jump : bool = false

@export_group("In air variables")
@export var in_air_move_speed : Curve
@export var in_air_accel : Curve

#gravity variables
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@export_group("Keybinding variables")
@export var moveForwardAction : String = ""
@export var moveBackwardAction : String = ""
@export var moveLeftAction : String = ""
@export var moveRightAction : String = ""
@export var runAction : String = ""
@export var jumpAction : String = ""

@export_group("Model variables")
@export var model_rot_speed : float
var is_waving : bool = false
@export var wave_on_floor_only : bool = false
@export var ragdoll_gravity : float
@export var ragdoll_on_floor_only : bool = false

#references variables
@onready var visual_root = %VisualRoot
@onready var godot_plush_skin = $VisualRoot/GodotPlushSkin
@onready var particles_manager = %ParticlesManager
@onready var cam_holder = $OrbitView
@onready var state_machine = $StateMachine
@onready var foot_step_audio = %FootStepAudio
@onready var impact_audio = %ImpactAudio
@onready var wave_audio = %WaveAudio
@onready var collision_shape_3d = %CollisionShape3D
@onready var floor_check : RayCast3D = $Raycasts/FloorRaycast

#particles variables
@onready var movement_dust = %MovementDust
@onready var jump_particles = preload("res://components/player/vfx/jump_particles.tscn")
@onready var land_particles = preload("res://components/player/vfx/land_particles.tscn")

func _ready():
	#set move variables, and value references
	move_speed = walk_speed
	move_accel = walk_accel
	move_deccel = walk_deccel
	
	jump_cooldown_ref = jump_cooldown
	nb_jumps_in_air_allowed_ref = nb_jumps_in_air_allowed
	coyote_jump_cooldown_ref = coyote_jump_cooldown
	
	#set model audios effects
	godot_plush_skin.waved.connect(wave_audio.play)
	godot_plush_skin.footstep.connect(func(intensity : float = 1.0):
		foot_step_audio.volume_db = linear_to_db(intensity)
		foot_step_audio.play()
		)
		
func _process(delta: float):
	modify_model_orientation(delta)
	
	#print(state_machine.curr_state_name)
	
func _physics_process(_delta : float):
	modify_physics_properties()
	
	move_and_slide()
	
func modify_model_orientation(delta : float):
	var dir_target_angle : float
	
	if cam_holder.cam_aimed:
		dir_target_angle = (cam_holder.cam.global_rotation.y) + PI
		visual_root.rotation.y = rotate_toward(visual_root.rotation.y, dir_target_angle, model_rot_speed * delta)
	elif !cam_holder.cam_aimed and move_dir != Vector2.ZERO:
		dir_target_angle = -move_dir.orthogonal().angle()
		visual_root.rotation.y = rotate_toward(visual_root.rotation.y, dir_target_angle, model_rot_speed * delta)
		
func modify_physics_properties():
	last_frame_position = position #get play char position every frame
	last_frame_velocity = velocity #get play char velocity every frame
	was_on_floor = !is_on_floor()
	
func gravity_apply(delta : float):
	#if play char goes up, apply jump gravity
	#otherwise, apply fall gravity
	if velocity.y >= 0.0: velocity.y -= jump_gravity * delta
	elif velocity.y < 0.0: velocity.y -= fall_gravity * delta
	
func squash_and_strech(value : float, timing : float):
	var sasTween : Tween = create_tween()
	sasTween.set_ease(Tween.EASE_OUT)
	sasTween.tween_property(godot_plush_skin, "squash_and_stretch", value, timing)
	sasTween.tween_property(godot_plush_skin, "squash_and_stretch", 1.0, timing * 1.8)
	
	
	
	
	
	
