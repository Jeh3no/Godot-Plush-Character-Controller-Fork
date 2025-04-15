extends State

class_name JumpState

var state_name : String = "Jump"

var cR : CharacterBody3D

func enter(char_ref : CharacterBody3D):
	cR = char_ref
	
	verifications()
	
	jump()
	
func verifications():
	cR.godot_plush_skin.set_state("jump")
	if cR.floor_snap_length != 0.0:  cR.floor_snap_length = 0.0
	if cR.jump_cooldown < cR.jump_cooldown_ref: cR.jump_cooldown = cR.jump_cooldown_ref
	if cR.movement_dust.emitting: cR.movement_dust.emitting = false
	
func update(_delta : float):
	pass
	
func physics_update(delta : float):
	
	applies(delta)
	
	cR.gravity_apply(delta)
	
	input_management()
	
	check_if_floor()
	
	move(delta)
	
func applies(delta : float):
	if !cR.is_on_floor(): 
		if cR.jump_cooldown > 0.0: cR.jump_cooldown -= delta
		if cR.coyote_jump_cooldown > 0.0: cR.coyote_jump_cooldown -= delta
		
func input_management():
	if Input.is_action_just_pressed(cR.jumpAction):
		jump()
		
	if Input.is_action_just_released(cR.jumpAction):
		#cut jump in action, allow to manage jump height 
		#(the longer you press the button, the more high the play char goes, similar to the Mario Bros games)
		cR.has_cut_jump = true
		transitioned.emit(self, "InairState")
		
	if Input.is_action_just_pressed("ragdoll"):
		if !cR.godot_plush_skin.ragdoll and !cR.ragdoll_on_floor_only:
			transitioned.emit(self, "RagdollState")
			
func check_if_floor():
	if !cR.is_on_floor() and cR.velocity.y < 0.0:
		transitioned.emit(self, "InairState")
		
	if cR.is_on_floor():
		if cR.move_dir: transitioned.emit(self, cR.walk_or_run)
		else: transitioned.emit(self, "IdleState")
		
	if cR.is_on_wall():
		#if enabled, cut velocity when the play char hit a wall
		if cR.hit_wall_cut_velocity:
			cR.velocity.x = 0.0
			cR.velocity.z = 0.0
			
func move(delta : float):
	cR.move_dir = Input.get_vector(cR.moveLeftAction, cR.moveRightAction, cR.moveForwardAction, cR.moveBackwardAction).rotated(-cR.cam_holder.global_rotation.y)
	
	#depending on the previous grounded state (walk or run)
	#choose corresponding curve, to apply the correct in air values
	if cR.move_dir and !cR.is_on_floor():
		var in_air_move_speed_val : float
		var in_air_accel_val : float
		if cR.walk_or_run == "WalkState":
			in_air_move_speed_val = cR.in_air_move_speed[0].sample(cR.velocity.length())
			in_air_accel_val = cR.in_air_accel[0].sample(cR.velocity.length())
		elif cR.walk_or_run == "RunState":
			in_air_move_speed_val = cR.in_air_move_speed[1].sample(cR.velocity.length())
			in_air_accel_val = cR.in_air_accel[1].sample(cR.velocity.length())
			
		cR.velocity.x = lerp(cR.velocity.x, cR.move_dir.x * in_air_move_speed_val, in_air_accel_val * delta)
		cR.velocity.z = lerp(cR.velocity.z, cR.move_dir.y * in_air_move_speed_val, in_air_accel_val * delta)
		
func jump(): 
	#manage the jump behaviour, depending of the different variables and states the character is
	
	var can_jump : bool = false #jump condition
	
	#in air jump
	if !cR.is_on_floor():
		if cR.coyote_jump_on:
			cR.jump_cooldown = cR.jump_cooldown_ref
			cR.coyote_jump_cooldown = -1.0 #so that the character cannot immediately make another coyote jump
			cR.coyote_jump_on = false
			can_jump = true 
		elif cR.nb_jumps_in_air_allowed > 0:
			cR.nb_jumps_in_air_allowed -= 1
			cR.jump_cooldown = cR.jump_cooldown_ref
			can_jump = true 
			
	#on floor jump
	if cR.is_on_floor():
		cR.jump_cooldown = cR.jump_cooldown_ref
		can_jump = true 
		
	#jump buffering
	if cR.buffered_jump:
		cR.buffered_jump = false
		cR.nb_jumps_in_air_allowed = cR.nb_jumps_in_air_allowed_ref
		
	#apply jump
	if can_jump:
		cR.velocity.y = -cR.jump_velocity
		can_jump = false
		
		#play squash and strech effect, and display jump particles
		if cR.is_on_floor(): 
			cR.squash_and_strech(1.12, 0.1)
			cR.particles_manager.display_particles(cR.jump_particles, cR)
		
		
