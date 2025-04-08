extends Node3D

func display_particles(particle_ref : PackedScene, char : CharacterBody3D):
	var particles : GPUParticles3D = particle_ref.instantiate()
	char.add_sibling(particles)
	particles.global_transform = char.global_transform
	particles.emitting = true
