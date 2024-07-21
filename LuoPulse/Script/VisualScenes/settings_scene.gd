extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("VBoxContainer/title_bar").get_node("HBoxContainer/Button").text = "设置"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
