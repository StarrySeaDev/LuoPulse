extends Area2D

func _ready():
	pass 


func _process(delta):
	pass


func _on_body_exited(body):
	print("missing")
	$"../MissingLabel".position.x = body.position.x + 140
	$"../MissingLabel/AnimationPlayer".play("fade_out")
	GlobalSystem.missing_count += 1
