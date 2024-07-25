extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_start_btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/Visual/select_scene.tscn")


func _on_res_mgr_btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/Visual/res_mgr_scene.tscn")


func _on_settings_btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/Visual/Settings/settings_scene.tscn")
