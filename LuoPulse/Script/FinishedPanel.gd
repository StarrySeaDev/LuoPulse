extends Panel


# 本场分数
var score : int = 0


func _ready():
	
	# 基本信息的展示
	var speed = 10
	var perfect = GlobalSystem.perfect_count
	var good = GlobalSystem.good_count
	var missing = GlobalSystem.missing_count
	
	$TitleLabel.text = GlobalSystem.selected_msc_title
	$InfoVBoxContainer/SPEEDHBoxContainer/SpeedLineEdit.text = str(speed)
	$InfoVBoxContainer/PERFECTHBoxContainer/PerfectLineEdit.text = str(perfect)
	$InfoVBoxContainer/GOODHBoxContainer/GoodLineEdit.text = str(good)
	$InfoVBoxContainer/MISSINGHBoxContainer/MissingLineEdit.text =  str(missing)
	
	# 计算分数
	score = speed * (perfect * 10 + good * 5 - missing * 5)
	
	$ScoreHBoxContainer/ScoreLineEdit.text = str(score)


func _on_next_button_button_down():
	GlobalScene.play_click_audio()
	
	# 打开计分文件
	var file = FileAccess.open(GlobalSystem.saved_msclist_path + GlobalSystem.selected_msc_title + "/" + "score.txt", FileAccess.WRITE_READ)
	
	# 文件未正常打开
	if file == null or !file.is_open():
		get_tree().change_scene_to_file("res://Scene/VisualScene/select_scene.tscn")
		return
	
	var data = file.get_as_text()
	
	# 如果文件为空
	if data == null:
		# 写入文件
		file.store_string(str(score))
		get_tree().change_scene_to_file("res://Scene/VisualScene/select_scene.tscn")
		return
	
	# 如果文件记录的分数小于本次获得分数
	if int(data) <= score:
		# 重写文件
		file.seek(0)
		file.store_string(str(score))
	
	# 关闭文件, 否则无法再次打开文件
	file.close()
	get_tree().change_scene_to_file("res://Scene/VisualScene/select_scene.tscn")


# 返回游戏
func _on_back_button_button_down():
	GlobalScene.play_click_audio()
	queue_free()
