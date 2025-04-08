extends State

class_name RagdollState

var state_name : String = "Ragdoll"

var cR : CharacterBody3D

func enter(char_ref : CharacterBody3D):
	#pass play char reference
	cR = char_ref
	
func update(delta : float):
	ragdoll_management()
	
func physics_update(delta : float):
	pass
	
func ragdoll_management():
	if !cR.godot_plush_skin.ragdoll: transitioned.emit(self, "IdleState")
	
