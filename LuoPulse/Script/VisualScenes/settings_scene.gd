extends Control

@onready var adjustSpinBox = $VBoxContainer/TabContainer/音频/MarginContainer/VBoxContainer/Adjust/AdjustSpinBox
@onready var volumeHSlider = $VBoxContainer/TabContainer/音频/MarginContainer/VBoxContainer/Volume/VolumeHSlider
@onready var lightHSlider = $VBoxContainer/TabContainer/视频/MarginContainer/VBoxContainer/Light/LightHSlider
@onready var track1_setbtn = $VBoxContainer/TabContainer/游戏/MarginContainer/VBoxContainer/TrackKey/Track1/Button
@onready var track2_setbtn = $VBoxContainer/TabContainer/游戏/MarginContainer/VBoxContainer/TrackKey/Track2/Button
@onready var track3_setbtn = $VBoxContainer/TabContainer/游戏/MarginContainer/VBoxContainer/TrackKey/Track3/Button
@onready var track4_setbtn = $VBoxContainer/TabContainer/游戏/MarginContainer/VBoxContainer/TrackKey/Track4/Button

# Called when the node enters the scene tree for the first time.
func _ready():
	# 标题栏设置
	get_node("VBoxContainer/title_bar").get_node("HBoxContainer/Button").text = "设置"
	
	adjustSpinBox.value = GlobalSystem.saved_adjustment
	volumeHSlider.value = GlobalSystem.saved_volume
	lightHSlider.value = GlobalSystem.saved_bg_light
	$VBoxContainer/TabContainer/游戏/MarginContainer/VBoxContainer/Path/PathTextEdit.text = GlobalSystem.saved_msclist_path
	track1_setbtn.text = GlobalSystem.saved_track_key[0]
	track2_setbtn.text = GlobalSystem.saved_track_key[1]
	track3_setbtn.text = GlobalSystem.saved_track_key[2]
	track4_setbtn.text = GlobalSystem.saved_track_key[3]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_bili_link_pressed():
	OS.shell_open("https://space.bilibili.com/1640232445")


func _on_gh_link_pressed():
	OS.shell_open("https://github.com/include-xb")


func _on_pj_link_pressed():
	OS.shell_open("https://github.com/include-xb/LuoPulse")


func _on_adjust_spin_box_value_changed(value):
	GlobalSystem.saved_adjustment = value


func _on_volume_h_slider_drag_ended(value_changed):
	GlobalSystem.saved_volume = value_changed


func _on_light_h_slider_drag_ended(value_changed):
	GlobalSystem.saved_bg_light = value_changed


func _on_bili_link_2_pressed():
	OS.shell_open("https://space.bilibili.com/1913343200")


func _on_gh_link_2_pressed():
	OS.shell_open("https://github.com/StarrySeaDev")


func _on_path_text_edit_text_submitted(path):
	GlobalSystem.saved_msclist_path = path
