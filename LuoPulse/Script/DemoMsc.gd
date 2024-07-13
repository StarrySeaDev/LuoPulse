extends Control


# 右边容器中的标题
@onready var MscTitleLable = $"../../../../Right/MscTitleLable"

# 音乐列表中歌曲标题
@onready var MscTitle = $MscTitle

# 右边容器中显示歌曲详细信息的标签
@onready var MscInfo = $"../../../../Right/InfoDiffi/InfoArea/InfoTextbox/MscInfo"

# 歌曲封面
@onready var BKImg = $"../../../../TextureRect"


func set_score():
	# 记录歌曲分数的文件
	var file_path = GlobalSystem.saved_msclist_path + MscTitle.text + "/" + "score.txt"
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	# 未打开文件, 分数设 0
	if file == null or !file.is_open():
		$ScoreTitle.text = str(0)
		return
	
	if file.is_open():
		var data = file.get_as_text()
		$ScoreTitle.text = data


func _on_info_button_button_down():
	
	GlobalScene.play_click_audio()
	
	# 加载歌曲封面图
	BKImg.texture = ImageTexture.create_from_image(
		Image.load_from_file(
			GlobalSystem.saved_msclist_path + MscTitle.text + "/cover.png"
		)
	)
	
	# 如果加载失败使用这一张图
	if BKImg.texture == null:
		BKImg.texture = load(GlobalSystem.default_msc_cover_path)
	
	# 写入全局变量
	GlobalSystem.selected_msc_cover = BKImg.texture
	
	MscTitleLable.text = MscTitle.text
	MscInfo.text = ""	# 清空显示歌曲详细信息的标签中的内容
	
	# 打开记录歌曲详细信息的文件
	var file = FileAccess.open(
		GlobalSystem.saved_msclist_path + MscTitle.text + "/info.txt", 
		FileAccess.READ
	)
	
	if file == null:
		return
	
	if !file.is_open():
		return
	
	while true:
		var data = file.get_line()  	# 逐行读取文件内容
		if data == "":  				# 判空跳过
			continue
		if data == "<EOF>": 			# 文件结束标志
			break
		MscInfo.text += '\n' + data 	# 写入标签
	file.close()						# 关闭文件
