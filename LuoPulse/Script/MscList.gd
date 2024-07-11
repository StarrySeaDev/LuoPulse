extends VBoxContainer

# 歌单加载路径 (后续添加到 setting 界面以更改路径)
var file_path = GlobalSystem.saved_msclist_path + "MscList.txt"

func _ready():
	
	# 根据路径打开歌单记录文件
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	if file == null:
		print("cannot open file")
		return
	
	if !file.is_open():
		print("error open file")
		return
	
	while true:
		var data = file.get_line()  	# 逐行读取
		if data == "":  				# 判空跳过
			continue
		if data == "<EOF>": 			# 结束标志
			break
		
		# 根据读取到的信息实例化歌单内容
		var msc : PackedScene = preload("res://Scene/WidgetScene/demo_msc.tscn")
		var instance : HBoxContainer = msc.instantiate()
		add_child(instance)
		
		# 设置歌单中歌曲标题
		instance.get_node("MscTitle").text = data
		instance.set_score()
		#################################################3
		
	file.close()	# 关闭文件
	
	# 在歌单最后添加分割线
	var separator = HSeparator.new()
	add_child(separator)
