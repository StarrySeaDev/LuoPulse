extends Control


func _ready():
	pass



func _process(delta):
	pass


func _on_home_button_button_down():
	GlobalScene.play_click_audio()
	get_tree().change_scene_to_file("res://Scene/VisualScene/start_scene.tscn")

"""
func _on_bilibili_button_button_down():
	OS.shell_open("")


func _on_git_hub_button_button_down():
	OS.shell_open("")
"""
