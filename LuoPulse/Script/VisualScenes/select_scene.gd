extends Control

@onready var mscList = $VBoxContainer/HBoxContainer/MscList
@onready var songInfo = $VBoxContainer/HBoxContainer/Control/VBoxContainer/SongInfo
@onready var songName = $VBoxContainer/HBoxContainer/Control/VBoxContainer/SongName
@onready var songList = []

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("VBoxContainer/title_bar").get_node("HBoxContainer/Button").text = "铺面列表"
	
	get_song_list()
	
	if(!songList.is_empty()):
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
		songList.append(data)
