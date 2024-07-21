extends Control


# Called when the node enters the scene tree for the first time.
func _ready():

	get_node("VBoxContainer/title_bar").get_node("HBoxContainer/Button").text = "铺面列表"
		
func _process(delta):
	pass
