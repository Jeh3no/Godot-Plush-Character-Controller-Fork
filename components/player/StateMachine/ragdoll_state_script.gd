extends State

class_name RagdollState

var state_name : String = "Ragdoll"

var cR : CharacterBody3D

func enter(char_ref : CharacterBody3D):
	#pass play char reference
	cR = char_ref
	
	apply_ragdoll()
	
	verifications()
	
func verifications():
	#manage the appliements that need to be set at the start of the state
	cR.floor_snap_length = 1.0
	if cR.jump_cooldown > 0.0: cR.jump_cooldown = -1.0
	if cR.nb_jumps_in_air_allowed < cR.nb_jumps_in_air_allowed_ref: cR.nb_jumps_in_air_allowed = cR.nb_jumps_in_air_allowed_ref
	if cR.coyote_jump_cooldown < cR.coyote_jump_cooldown_ref: cR.coyote_jump_cooldown = cR.coyote_jump_cooldown_ref
	if cR.movement_dust.emitting: cR.movement_dust.emitting = false
	
func apply_ragdoll():
	cR.godot_plush_skin.ragdoll = true
	
func update(_delta : float):
	check_if_ragdoll()
	
func physics_update(delta : float):
	gravity_apply(delta)
	
	applies()
	
	input_management()
	
func check_if_ragdoll():
	if !cR.godot_plush_skin.ragdoll:
		transitioned.emit(self, "IdleState")
		
func gravity_apply(delta : float):
	cR.velocity.y -= cR.ragdoll_gravity * delta #apply distant gravity value to follow the model (if wanted)
	
func applies():
	#have to apply it every frame, otherwise the camera will continue to move
	cR.velocity.x = 0.0
	cR.velocity.z = 0.0
	
func input_management():
	if Input.is_action_just_pressed("ragdoll"):
		if cR.ragdoll_on_floor_only and cR.is_on_floor():
			cR.godot_plush_skin.ragdoll = false
		elif !cR.ragdoll_on_floor_only: #and so whatever if he's on the floor or not
			cR.godot_plush_skin.ragdoll = false
	
