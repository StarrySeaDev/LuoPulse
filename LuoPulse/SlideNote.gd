extends CharacterBody2D

# @export var length = 1

@export var height = 48.0

func _ready():
	pass


func set_height(sec):
	
	scale.y = GlobalScene.sec_to_length(sec) / height

	pass
