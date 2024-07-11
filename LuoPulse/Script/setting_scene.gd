extends Control

# 误差调整
@onready var adjust = $ScrollContainer/HBoxContainer/Adjust/AdjustSpinBox

# 音量设置
@onready var volume = $ScrollContainer/HBoxContainer/Volume/VolumeHSlider

# 歌单路径
@onready var path = $ScrollContainer/HBoxContainer/Path/PathTextEdit

func default_setting():
	adjust.value = GlobalSystem.default_adjustment
	volume.value = GlobalSystem.default_volume
	path.text = GlobalSystem.default_msclist_path


func _ready():
	adjust.value = GlobalSystem.saved_adjustment
	volume.value = GlobalSystem.saved_volume
	path.text = GlobalSystem.saved_msclist_path
	
	
func _process(delta):
	pass


func _on_default_button_button_down():
	GlobalScene.play_click_audio()
	default_setting()


func _on_save_button_button_down():
	
	GlobalScene.set_volume(volume.value)
	GlobalScene.play_click_audio()
	
	if path.text[path.text.length() - 1] != "/" and path.text[path.text.length() - 1] != "\\":
		path.text += "/"
	
	GlobalSystem.saved_adjustment = adjust.value
	GlobalSystem.saved_volume = volume.value
	GlobalSystem.saved_msclist_path = path.text
	get_tree().change_scene_to_file("res://Scene/VisualScene/start_scene.tscn")


func _on_volume_h_slider_value_changed(value):
	GlobalScene.set_volume(volume.value)
	GlobalScene.play_click_audio()


func _on_adjust_spin_box_value_changed(value):
	GlobalScene.play_click_audio()
