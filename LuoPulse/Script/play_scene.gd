extends Node2D


@onready var notes = $PlayPanel/Notes

var notes_path = GlobalSystem.saved_msclist_path + \
					 GlobalSystem.selected_msc_title + "/" + \
					 GlobalSystem.selected_msc_title + ".txt"


var file = FileAccess.open(notes_path, FileAccess.READ)

var is_first_note = true

var first_note : CharacterBody2D

var total_duration = 0.0

var current_position = 0.0

var remaining_time = 0.0

signal finished

var is_running = true

var is_loading_note = true

var total_note_num = 1.0

var loaded_note_num = 0.0


func _ready():
	
	get_tree().paused = true
	
	$LoadingPanel.visible = true
	
	file = FileAccess.open(notes_path, FileAccess.READ)
	
	if file == null:
		print("cannot open file")
		return
	
	if !file.is_open():
		print("error open file")
		return
	
	
	# load_msc_notes()
	
	finished.connect(display_finish_panel)
	
	var audio_path = GlobalSystem.saved_msclist_path + GlobalSystem.selected_msc_title + "/" + "audio.mp3"
	
	# $AudioStreamPlayer2D.stream = load(audio_path)
	
	var audio_file = FileAccess.open(audio_path, FileAccess.READ)
	var sound = AudioStreamMP3.new()
	sound.data = audio_file.get_buffer(audio_file.get_length())
	$AudioStreamPlayer2D.stream = sound
	
	print(GlobalSystem.saved_msclist_path + GlobalSystem.selected_msc_title + "/" + "audio.mp3")
	
	# 获取音频的总时长（秒）
	total_duration = $AudioStreamPlayer2D.stream.get_length()
	# print(total_duration)
	
	# 开始时暂停菜单是隐藏状态
	$MenuPanel.visible = false
	
	# 开始时 missing 标签是隐藏状态
	$PlayPanel/MissingLabel.visible = false
	
	$PlayPanel/MissingLabel.position.y = 540
	
	# 判空则使用默认
	if GlobalSystem.selected_msc_cover == null:
		GlobalSystem.selected_msc_cover = preload("res://Resource/Img/17.png")
	
	# 加载背景图片 即歌曲封面
	$TextureRect.texture = GlobalSystem.selected_msc_cover


func start_audio():
	$AudioStreamPlayer2D.play()
	$AudioStreamPlayer2D.volume_db = linear_to_db(GlobalSystem.saved_volume * 0.01)


func _process(delta):
	
	if is_loading_note:
		var data = file.get_line()
		
		if data == "" or data[0] == "-":
			# continue
			return
			
		if data == "<bpm>":
			data = file.get_line()
			GlobalSystem.bpm = float(data)
			# continue
			return
		
		if data == "<bpp>":
			data = file.get_line()
			GlobalSystem.bpp = int(data)
			# continue
			return
		
		if data == "<dt>":
			data = file.get_line()
			GlobalSystem.dt = float(data)
			# continue
			return
			
		if data == "<del>":
			data = file.get_line()
			GlobalSystem.del = float(data)
			# continue
			return
		
		if data == "<tal>":
			data = file.get_line()
			total_note_num = int(data)
			# continue
			return
		
		if data =="<p>" or data == "<P>":
			data = file.get_line()
			GlobalSystem.phara = int(data) - 1
			# continue
			return
			
		if data == "<EOF>":
			file.close()
			
			get_tree().paused = false
			
			GlobalSystem.is_running_note = true
			
			print("put note finished!!!")
			
			is_loading_note = false
			
			$LoadingPanel.visible = false
			
			return
		
		var note = data.split(":")
		
		# 加载音符
		var single_note = load("res://Scene/WidgetScene/single_note.tscn")
		var instance : CharacterBody2D = single_note.instantiate()
		notes.add_child(instance)
		
		loaded_note_num += 1
		
		$LoadingPanel/ProgressBar.value = int(loaded_note_num / total_note_num * 100)
		
		# 计算音符坐标
		instance.position.x = 100 * float(note[0]) - 250
		instance.position.y = GlobalScene.sec_to_length(float(note[1]) + GlobalSystem.bpp * GlobalSystem.phara )
		
		if is_first_note:
			is_first_note = false
			first_note = instance
			first_note.name = "FIRST"
			$StartAudArea2D.position.y = 185 - 10 * GlobalSystem.saved_difficulty * 60 * ( GlobalSystem.dt + GlobalSystem.saved_adjustment)
			print("note: ", first_note.position.y)
			print("area: ", $StartAudArea2D.position.y)

	
	if Input.is_key_pressed(KEY_ESCAPE):
		_on_menu_button_button_down()
	if Input.is_key_pressed(KEY_SPACE):
		_on_resume_button_button_down()
	
	$VBoxContainer/MissingHBoxContainer/MissingCountLineEdit.text = str(GlobalSystem.missing_count)
	$VBoxContainer/PerfectHBoxContainer/PerfectCountLineEdit.text = str(GlobalSystem.perfect_count)
	$VBoxContainer/GoodHBoxContainer/GoodCountLineEdit.text = str(GlobalSystem.good_count)
	
	current_position = $AudioStreamPlayer2D.get_playback_position()
	
	remaining_time = total_duration - current_position

	
	if remaining_time <= GlobalSystem.del and is_running:
		print("finished")
		emit_signal("finished")
		is_running = false

# 打开暂停菜单
func _on_menu_button_button_down():
	
	GlobalScene.play_click_audio()
	
	# 显示菜单
	$MenuPanel.visible = true
	
	# 暂停游戏
	get_tree().paused = $MenuPanel.visible
	
	# 打开暂停菜单的按钮需要随游戏暂停状态而切换可见性
	$MenuButton.visible = !get_tree().paused


# 继续游戏 在暂停菜单内
func _on_resume_button_button_down():
	
	GlobalScene.play_click_audio()
	
	# 隐藏暂停菜单
	$MenuPanel.visible = false
	
	# 继续游戏
	get_tree().paused = $MenuPanel.visible
	
	# 打开暂停菜单的按钮需要随游戏暂停状态而切换可见性
	$MenuButton.visible = !get_tree().paused
	
	#$PlayPanel/Notes.position.y -= GlobalScene.sec_to_length(5)
	###


# 直接结束游戏
func _on_home_button_button_down():
	GlobalScene.play_click_audio()
	
	get_tree().paused = true
	emit_signal("finished")


func _on_view_button_button_down():
	GlobalScene.play_click_audio()
	OS.shell_open(notes_path)


# 开始播放音乐判定
var b = true
func _on_start_aud_area_2d_body_entered(body : CharacterBody2D):
	if true and b:
		print("first note enter the area, start audio")
		b = false
		start_audio()


func display_finish_panel():
	var panel : PackedScene = preload("res://Scene/WidgetScene/finished_panel.tscn")
	var instance : Panel = panel.instantiate()
	add_child(instance)
