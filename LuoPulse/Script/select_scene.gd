extends Control

@onready var DifficDegree = $Right/InfoDiffi/DifficultyArea/DifficultyDegree

@onready var TipLable = $Right/InfoDiffi/DifficultyArea/TipLable

var tip_text : String

func _ready():
	GlobalSystem.init()
	# $WaitPanel.visible = false


@warning_ignore("unused_parameter")
func _process(delta):
	if DifficDegree.value == 1:
		tip_text = " 简单 EASY "
	if DifficDegree.value == 2:
		tip_text = " 中等 SECONDARY "
	if DifficDegree.value == 3:
		tip_text = " 困难 HARD "
	
	TipLable.text = tip_text


# 返回主菜单 按钮在左上角
func _on_home_button_button_down():
	GlobalScene.play_click_audio()
	get_tree().change_scene_to_file("res://Scene/VisualScene/start_scene.tscn")


# 开始游戏 按钮在右下角
func _on_start_button_button_down():
	# $WaitPanel.visible = true
	GlobalScene.play_click_audio()
	# yield()
	GlobalSystem.saved_difficulty = $Right/InfoDiffi/DifficultyArea/DifficultyDegree.value
	GlobalSystem.selected_msc_title = $Right/MscTitleLable.text
	print("diffic" + str(GlobalSystem.saved_difficulty))
	if $Right/InfoDiffi/InfoArea/InfoTextbox/MscInfo.text == "选择歌曲":
		print("no selecting")
		return
	get_tree().change_scene_to_file("res://Scene/VisualScene/play_scene.tscn")


func _on_difficulty_degree_value_changed(value):
	GlobalScene.play_click_audio()
