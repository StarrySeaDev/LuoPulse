extends Area2D


@export_enum("D", "F", "J", "K" ) var POS: String

@onready var tip_lable = $"../../TipLabel"

@onready var tip_animation_player = $"../../TipLabel/AnimationPlayer"

var able_to_judge = false
var current_body : SINGLE_NOTE


func _ready():
	pass



func _process(delta):
	if Input.is_action_pressed("PS_" + POS):
		
		#print(get_node("../../../BackPanel/Panel"+POS).modulate)
		
		get_node("../../../BackPanel/Panel"+POS).modulate = Color(1, 1, 1, 0.5)
		
		if able_to_judge:
			GlobalScene.play_hit_audio()
			if abs(current_body.position.y - 185) <= 10 - GlobalSystem.saved_difficulty * 2:
				GlobalSystem.perfect_count += 1
				
				tip_lable.text = "PERFECT"
				tip_animation_player.play("fadeout")
				
			else:
				GlobalSystem.good_count += 1

			current_body.kill()
	else:
		get_node("../../../BackPanel/Panel"+POS).modulate = Color(1, 1, 1, 1)


func _on_body_entered(body):
	able_to_judge = true
	current_body = body


func _on_body_exited(body):
	able_to_judge = false
