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
	
	# 加载画面
	$LoadingPanel.visible = true
	
	file = FileAccess.open(notes_path, FileAccess.READ)
	
	if file == null:
		return
	
	if !file.is_open():
		return
	
	# finished 信号连接
	finished.connect(display_finish_panel)
	
	# 外部加载歌曲
	var audio_path = GlobalSystem.saved_msclist_path + GlobalSystem.selected_msc_title + "/" + "audio.mp3"
	var audio_file = FileAccess.open(audio_path, FileAccess.READ)
	var sound = AudioStreamMP3.new()
	sound.data = audio_file.get_buffer(audio_file.get_length())
	$AudioStreamPlayer2D.stream = sound
	
	# 获取音频的总时长（秒）
	total_duration = $AudioStreamPlayer2D.stream.get_length()
	
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


@warning_ignore("unused_parameter")
func _process(delta):
	# 正在加载音符
	if is_loading_note:
		var data = file.get_line()
		
		if data == "" or data[0] == "-":
			return
		
		# 获取bpm
		if data == "<bpm>":
			data = file.get_line()
			GlobalSystem.bpm = float(data)
			return
		
		# 获取每小节有几拍
		if data == "<bpp>":
			data = file.get_line()
			GlobalSystem.bpp = int(data)
			return
		
		# 获取开头延时
		if data == "<dt>":
			data = file.get_line()
			GlobalSystem.dt = float(data)
			return
		
		# 获取最后减去时长
		if data == "<del>":
			data = file.get_line()
			GlobalSystem.del = float(data)
			return
		
		# 获取音符总数
		if data == "<tal>":
			data = file.get_line()
			total_note_num = int(data)
			return
		
		# 获取小节数
		if data =="<p>" or data == "<P>":
			data = file.get_line()
			GlobalSystem.phara = int(data) - 1
			return
		
		# 结束读取
		if data == "<EOF>":
			file.close()
			
			get_tree().paused = false
			
			# 开始让音符下落
			GlobalSystem.is_running_note = true
			
			# 结束加载
			is_loading_note = false
			
			# 加载画面结束
			$LoadingPanel.visible = false
			
			return
		
		var note = data.split(":")
		
		# 加载音符
		var single_note = load("res://Scene/WidgetScene/single_note.tscn")
		var instance : CharacterBody2D = single_note.instantiate()
		notes.add_child(instance)
		
		# 已加载的音符数加 1
		loaded_note_num += 1
		
		# 计算进度条进度
		$LoadingPanel/ProgressBar.value = int(loaded_note_num / total_note_num * 100)
		
		# 计算音符坐标
		instance.position.x = 100 * float(note[0]) - 250
		instance.position.y = GlobalScene.sec_to_length(float(note[1]) + GlobalSystem.bpp * GlobalSystem.phara )
		
		# 如果是第一个音符被初始化时
		if is_first_note:
			# 确保这部分只被运行一次
			is_first_note = false
			first_note = instance
			
			# 以 FIRST 标记这个音符
			first_note.name = "FIRST"
			
			# 设置一个检测音符碰撞的碰撞箱, 如果第一个音符碰撞, 开始播放歌曲
			$StartAudArea2D.position.y = 185 - 10 * GlobalSystem.saved_difficulty * 60 * ( GlobalSystem.dt + GlobalSystem.saved_adjustment)
			
			#print("note: ", first_note.position.y)
			#print("area: ", $StartAudArea2D.position.y
	# 如果按下 ESC
	if Input.is_key_pressed(KEY_ESCAPE):
		_on_menu_button_button_down()
	
	# 如果按下 SPACE
	if Input.is_key_pressed(KEY_SPACE):
		_on_resume_button_button_down()
	
	# 三个统计
	$VBoxContainer/MissingHBoxContainer/MissingCountLineEdit.text = str(GlobalSystem.missing_count)
	$VBoxContainer/PerfectHBoxContainer/PerfectCountLineEdit.text = str(GlobalSystem.perfect_count)
	$VBoxContainer/GoodHBoxContainer/GoodCountLineEdit.text = str(GlobalSystem.good_count)
	
	# 获取当前歌曲播放位置
	current_position = $AudioStreamPlayer2D.get_playback_position()
	
	# 计算歌曲剩余时长
	remaining_time = total_duration - current_position

	# 如果剩余时长小于已读取到的最后减去时长
	if remaining_time <= GlobalSystem.del and is_running:
		# 广播结束信号
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


# 直接结束游戏
func _on_home_button_button_down():
	GlobalScene.play_click_audio()
	
	get_tree().paused = true
	emit_signal("finished")


# 打开谱面文件
func _on_view_button_button_down():
	GlobalScene.play_click_audio()
	OS.shell_open(notes_path)


# 开始播放音乐判定
var b = true
func _on_start_aud_area_2d_body_entered(body : CharacterBody2D):
	if body.name == "FIRST" and b:
		# 确保这部分代码只运行一次
		b = false
		start_audio()


# 结束 展示结算画面
func display_finish_panel():
	var panel : PackedScene = preload("res://Scene/WidgetScene/finished_panel.tscn")
	var instance : Panel = panel.instantiate()
	add_child(instance)
