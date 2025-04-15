extends CanvasLayer

#there won't be any more commentaries for this script, i think the functions are pretty self explanatory

#L stands for "Label", LT stands for "Label Text"
@onready var current_state_LT = %CurrentStateLT
@onready var velocity_LT = %VelocityLT
@onready var nb_jumps_inAir_allowed_LT = %NbJumpsInAirAllowedLT
@onready var jump_buffer_LT = %JumpBufferLT
@onready var coyote_time_LT = %CoyoteTimeLT
@onready var model_orientation_LT = %ModelOrientationLT
@onready var camera_mode_LT = %CameraModeLT
@onready var frames_per_second_LT = %FramesPerSecondLT

func display_curr_state(curr_state : String):
	current_state_LT.set_text(str(curr_state))
	
func display_velocity(velocity : float):
	velocity_LT.set_text(str(velocity))

func display_nb_jumps_in_air_allowed(nb_jumps : int):
	nb_jumps_inAir_allowed_LT.set_text(str(nb_jumps))
	
func display_jump_buffer(jump_buffer : bool):
	jump_buffer_LT.set_text(str(jump_buffer if jump_buffer else ""))
	
func display_coyote_time(coyote_time : float):
	coyote_time_LT.set_text(str(coyote_time))
	
func display_model_orientation(model_orientation : bool):
	model_orientation_LT.set_text(str("cam follower" if model_orientation else "independant"))
	
func display_camera_mode(cam_mode : bool):
	camera_mode_LT.set_text(str("aim" if cam_mode else "default"))
	
func _process(_delta : float):
	display_frames_per_second()
	
func display_frames_per_second():
	frames_per_second_LT.set_text(str(Engine.get_frames_per_second()))
	
	
	
	
