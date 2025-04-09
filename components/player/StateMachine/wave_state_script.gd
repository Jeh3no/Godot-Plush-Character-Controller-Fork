extends State

class_name WaveState

var state_name : String = "Wave"

var cR : CharacterBody3D

func enter(char_ref : CharacterBody3D):
	#pass play char reference
	cR = char_ref
	
	apply_wave()
	
	verifications()
	
func verifications():
	#manage the appliements that need to be set at the start of the state
	cR.floor_snap_length = 1.0
	if cR.jump_cooldown > 0.0: cR.jump_cooldown = -1.0
	if cR.nb_jumps_in_air_allowed < cR.nb_jumps_in_air_allowed_ref: cR.nb_jumps_in_air_allowed = cR.nb_jumps_in_air_allowed_ref
	if cR.coyote_jump_cooldown < cR.coyote_jump_cooldown_ref: cR.coyote_jump_cooldown = cR.coyote_jump_cooldown_ref
	if cR.movement_dust.emitting: cR.movement_dust.emitting = false
	
func apply_wave():
	cR.godot_plush_skin.wave()
	
func update(_delta : float):
	check_if_is_waving()
	
func physics_update(delta : float):
	cR.gravity_apply(delta)
	
	move(delta)
	
func check_if_is_waving():
	if !cR.godot_plush_skin.is_waving():
		transitioned.emit(self, "IdleState")
	else:
		print("is waving")
		
func move(delta : float):
	cR.velocity.x = lerp(cR.velocity.x, 0.0, cR.move_deccel * delta)
	cR.velocity.z = lerp(cR.velocity.z, 0.0, cR.move_deccel * delta)
