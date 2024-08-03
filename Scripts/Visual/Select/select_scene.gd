extends Control

var chartNameList: Array = RunningData.chartList
var artistsList: Array = []
var picList: Array = []

@onready var listView: VBoxContainer = $"VBoxContainer/HBoxContainer/ChartList/ScrollContainer/VBoxContainer"

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in RunningData.chartList:
		var path: String = "user://MscList/" + i + "/"
		# 加载图片到列表
		var pic: Resource = load(path + "cover.png")
		picList.append(pic)

		# 读staff信息
		var artists: String = FileAccess.get_file_as_string((path + "info.txt"))
		artistsList.append(artists)
	
	for i in chartNameList.size():
		var item: Node = preload("res://Scenes/Widgets/select_chart_item.tscn").instantiate()
		item.set_up(chartNameList[i], artistsList[i], i)
		listView.add_child(item)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Visual/hub_scene.tscn")

