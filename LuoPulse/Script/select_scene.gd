extends Control


# 难度选择
@onready var DifficDegree = $Right/InfoDiffi/DifficultyArea/DifficultyDegree

# 简单 中等 困难
@onready var TipLable = $Right/InfoDiffi/DifficultyArea/TipLable

# 简单 中等 困难
var tip_text : String


func _ready():
	GlobalSystem.init()


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
	GlobalScene.play_click_audio()
	
	# 保存选择的信息
	GlobalSystem.saved_difficulty = $Right/InfoDiffi/DifficultyArea/DifficultyDegree.value
	GlobalSystem.selected_msc_title = $Right/MscTitleLable.text
	
	# 如果没有选择
	if $Right/InfoDiffi/InfoArea/InfoTextbox/MscInfo.text == "选择歌曲":
		# print("no selecting")
		return
	
	# 转入游戏场景
	get_tree().change_scene_to_file("res://Scene/VisualScene/play_scene.tscn")


@warning_ignore("unused_parameter")
func _on_difficulty_degree_value_changed(value):
	GlobalScene.play_click_audio()
