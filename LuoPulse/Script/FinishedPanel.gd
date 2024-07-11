extends Panel

var score : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var speed = GlobalSystem.saved_difficulty * 10
	var perfect = GlobalSystem.perfect_count
	var good = GlobalSystem.good_count
	var missing = GlobalSystem.missing_count
	
	$TitleLabel.text = GlobalSystem.selected_msc_title
	$InfoVBoxContainer/SPEEDHBoxContainer/SpeedLineEdit.text = str(speed)
	$InfoVBoxContainer/PERFECTHBoxContainer/PerfectLineEdit.text = str(perfect)
	$InfoVBoxContainer/GOODHBoxContainer/GoodLineEdit.text = str(good)
	$InfoVBoxContainer/MISSINGHBoxContainer/MissingLineEdit.text =  str(missing)
	
	score = speed * (perfect * 10 + good * 5 - missing * 5)
	
	$ScoreHBoxContainer/ScoreLineEdit.text = str(score)

func _process(delta):
	pass


func _on_next_button_button_down():
	GlobalScene.play_click_audio()
	
	var file = FileAccess.open(GlobalSystem.saved_msclist_path + GlobalSystem.selected_msc_title + "/" + "score.txt", FileAccess.WRITE_READ)
	
	print(GlobalSystem.saved_msclist_path + GlobalSystem.selected_msc_title + "/" + "score.txt")
	
	# 文件未正常打开
	if file == null or !file.is_open():
		get_tree().change_scene_to_file("res://Scene/VisualScene/select_scene.tscn")
		return
	
	var data = file.get_line()
	if data == null:
		file.store_string(str(score))
		get_tree().change_scene_to_file("res://Scene/VisualScene/select_scene.tscn")
		return
	
	if int(data) <= score:
		print(data)
		print(score)
		file.seek(0)
		file.store_string(str(score))
		get_tree().change_scene_to_file("res://Scene/VisualScene/select_scene.tscn")
	
	file.close()


func _on_back_button_button_down():
	GlobalScene.play_click_audio()
	queue_free()
