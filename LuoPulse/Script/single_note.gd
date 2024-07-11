extends CharacterBody2D

class_name SINGLE_NOTE

@export var deathParticle : PackedScene = null

# 速度
var speed = 10

var is_set = false


func _ready():
	# print("speed" + str(speed))
	
	GlobalSystem.is_running_note = false


# 物理下落
func _physics_process(delta):
	move_and_collide(velocity)


func _process(delta):
	if GlobalSystem.is_running_note and !is_set:
		print("loaded")
		velocity.y = speed
		is_set = true


func kill():
	var particle : PackedScene = preload("res://Scene/WidgetScene/gpu_particles_2d.tscn")
	var instance : GPUParticles2D = particle.instantiate()
	
	get_tree().current_scene.add_child(instance)
	
	instance.position = global_position
	
	instance.emitting = true
	
	print("instance position:", instance.global_position)
	
	queue_free()
