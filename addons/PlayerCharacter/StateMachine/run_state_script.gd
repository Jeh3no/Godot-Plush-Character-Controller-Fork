extends State

class_name RunState

var state_name : String = "Run"

var cR : CharacterBody3D

func enter(char_ref : CharacterBody3D):
	cR = char_ref
	
	verifications()
	
func verifications():
	cR.godot_plush_skin.set_state("run")
	cR.move_speed = cR.run_speed
	cR.move_accel = cR.run_accel
	cR.move_deccel = cR.run_deccel
	
	cR.floor_snap_length = 1.0
	if cR.jump_cooldown > 0.0: cR.jump_cooldown = -1.0
	if cR.nb_jumps_in_air_allowed < cR.nb_jumps_in_air_allowed_ref: cR.nb_jumps_in_air_allowed = cR.nb_jumps_in_air_allowed_ref
	if cR.coyote_jump_cooldown < cR.coyote_jump_cooldown_ref: cR.coyote_jump_cooldown = cR.coyote_jump_cooldown_ref
	if cR.has_cut_jump: cR.has_cut_jump = false
	if !cR.movement_dust.emitting: cR.movement_dust.emitting = true
	
func update(_delta : float):
	pass
	
func physics_update(delta : float):
	check_if_floor()
	
	cR.gravity_apply(delta)
	
	input_management()
	
	move(delta)
	
func check_if_floor():
	if !cR.is_on_floor():
		if cR.velocity.y < 0.0:
			transitioned.emit(self, "InairState")
			
	if cR.is_on_floor():
		if cR.jump_buff_on:
			cR.buffered_jump = true
			cR.jump_buff_on = false
			transitioned.emit(self, "JumpState")
			
func input_management():
	if Input.is_action_pressed(cR.jumpAction) if cR.auto_jump else Input.is_action_just_pressed(cR.jumpAction) :
		transitioned.emit(self, "JumpState")
		
	if cR.continious_run:
		#has to press run button once to run
		if Input.is_action_just_pressed(cR.runAction):
			cR.walk_or_run = "WalkState"
			transitioned.emit(self, "WalkState")
	else:
		#has to continuously press run button to run
		if !Input.is_action_pressed(cR.runAction):
			cR.walk_or_run = "WalkState"
			transitioned.emit(self, "WalkState")
			
	if Input.is_action_just_pressed("ragdoll"):
		if !cR.godot_plush_skin.ragdoll:
			transitioned.emit(self, "RagdollState")
		
		
func move(delta : float):
	cR.move_dir = Input.get_vector(cR.moveLeftAction, cR.moveRightAction, cR.moveForwardAction, cR.moveBackwardAction).rotated(-cR.cam_holder.global_rotation.y)
	
	if cR.move_dir and cR.is_on_floor():
		cR.velocity.x = lerp(cR.velocity.x, cR.move_dir.x * cR.move_speed, cR.move_accel * delta)
		cR.velocity.z = lerp(cR.velocity.z, cR.move_dir.y * cR.move_speed, cR.move_accel * delta)
	else:
		transitioned.emit(self, "IdleState")
