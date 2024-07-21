extends ItemList


# Called when the node enters the scene tree for the first time.
func _ready():
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
		add_item(data)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
