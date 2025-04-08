extends State

class_name InairState

var state_name : String = "Inair"

var cR : CharacterBody3D

func enter(char_ref : CharacterBody3D):
	cR = char_ref
	
	verifications()
	
func verifications():
	cR.godot_plush_skin.set_state("fall")
	if cR.floor_snap_length != 0.0:  cR.floor_snap_length = 0.0
	#if cR.hitGroundCooldown != cR.hitGroundCooldownRef: cR.hitGroundCooldown = cR.hitGroundCooldownRef
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
		#check if can jump buffer
		if cR.floor_check.is_colliding() and cR.last_frame_position.y > cR.position.y and cR.nb_jumps_in_air_allowed <= 0: cR.jump_buff_on = true
		#check if can coyote jump
		if cR.was_on_floor and cR.coyote_jump_cooldown > 0.0 and cR.last_frame_position.y > cR.position.y:
			cR.coyote_jump_on = true
			transitioned.emit(self, "JumpState")
		transitioned.emit(self, "JumpState")
		
func check_if_floor():
	if cR.is_on_floor():
		if cR.jump_buff_on: 
			cR.buffered_jump = true
			cR.jump_buff_on = false
			transitioned.emit(self, "JumpState")
			
		cR.squash_and_strech(0.8, 0.08)
		cR.particles_manager.display_particles(cR.land_particles, cR)
		
		if cR.move_dir: transitioned.emit(self, cR.walk_or_run)
		else: transitioned.emit(self, "IdleState")
		
func move(delta : float):
	cR.move_dir = Input.get_vector(cR.moveLeftAction, cR.moveRightAction, cR.moveForwardAction, cR.moveBackwardAction).rotated(-cR.cam_holder.global_rotation.y)
		
	if cR.move_dir and !cR.is_on_floor():
		var in_air_move_speed_val : float = 12.0
		var in_air_accel_val : float = 8.0
		
		cR.velocity.x = lerp(cR.velocity.x, cR.move_dir.x * in_air_move_speed_val, in_air_accel_val * delta)
		cR.velocity.z = lerp(cR.velocity.z, cR.move_dir.y * in_air_move_speed_val, in_air_accel_val * delta)
