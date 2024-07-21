extends Control

@onready var mscListView = $VBoxContainer/HBoxContainer/MscList
@onready var songName = $VBoxContainer/HBoxContainer/Control/VBoxContainer/SongName
@onready var textureRect = $TextureRect

# 歌曲列表
var mscList = []

# 歌曲信息
var mscInfo = []

# itemlist选中项目index
var currentIndex = 0

# 得分列表
var score = []

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("VBoxContainer/title_bar").get_node("HBoxContainer/Button").text = "铺面列表"
	
	GlobalSystem.init()
	
	get_song_list()
	get_score()
	
	if(!mscList.is_empty()):
		mscListView.item = mscList
		get_node("VBoxContainer/HBoxContainer/Control/VBoxContainer").visible = true
	
func _process(delta):
	pass
	
# 获取铺面列表
func get_song_list():
	# 根据路径打开歌单记录文件
	var file = FileAccess.open("MscList.txt", FileAccess.READ)
	
	if file == null:
		return
	
	if !file.is_open():
		return
	
	while true:
		var data = file.get_line()  	# 逐行读取
		if data == "":  				# 判空跳过
			continue
		if data == "<EOF>": 			# 结束标志
			break
		mscList.append(data)

# 获取分数
func get_score():
	for i in mscList:
		
		# 记录歌曲分数的文件
		var file_path = GlobalSystem.saved_msclist_path + i.text + "/" + "score.txt"
		var file = FileAccess.open(file_path, FileAccess.READ)
		
		# 未打开文件, 分数设 0
		if file == null or !file.is_open():
			score.append(0)
			return
		
		if file.is_open():
			var data = file.get_as_text()
			score.append(data)

# 获取歌曲信息
func get_song_info():
	
	for i in mscList:
		# 打开记录歌曲详细信息的文件
		var file = FileAccess.open(
			GlobalSystem.saved_msclist_path + i + "/info.txt", 
			FileAccess.READ
		)
		
		while true:
			var data = file.get_line()  	# 逐行读取文件内容
			if data == "":  				# 判空跳过
				continue
			if data == "<EOF>": 			# 文件结束标志
				break
			mscInfo.append(data) # 加入列表
		file.close()

func _on_msc_list_item_selected(index):
	currentIndex = index
	
	# 设置背景
	textureRect.texture = ImageTexture.create_from_image(
		Image.load_from_file(
			GlobalSystem.saved_msclist_path + mscList[index] + "/cover.png"
		)
	)


func _on_start_button_pressed():
	GlobalSystem.selected_msc_title = mscList[currentIndex]
	
	GlobalScene.play_click_audio()
	get_tree().change_scene_to_file("res://Scene/VisualScene/play_scene.tscn")
