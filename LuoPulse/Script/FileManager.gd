extends Node

var file_path = "res://Resource/MscList/MscList.txt"

var file

func read_msclist():
	var file = FileAccess.open(file_path, FileAccess.READ)
	while true:
		var data = file.get_line()
		if data == "<EOF>":
			break;
		print(data)
	file.close()
	
		
