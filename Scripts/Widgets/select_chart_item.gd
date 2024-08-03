extends PanelContainer

signal selected(index: int)

var index: int = 0

var unchoosenStyle: StyleBoxFlat = StyleBoxFlat.new()
var choosedStyle: StyleBoxFlat = StyleBoxFlat.new()

# 设置标签
func set_up(chartName: String, artistsInfo: String, index: int) -> void:
	self.index = index
	
	unchoosenStyle.bg_color = Color(0, 0, 0, 0)
	choosedStyle.bg_color = Color("#66ccffbf")
	choosedStyle.set_corner_radius_all(10)
	
	$"VBoxContainer/NameLabel".text = chartName
	$"VBoxContainer/ArLabel".text = artistsInfo

	if RunningData.lastetChoosen == index:
		$".".add_theme_stylebox_override("a", choosedStyle)
	else:
		$".".add_theme_stylebox_override("a", unchoosenStyle)
	
func _on_gui_input(event):
	if (event == InputEventScreenTouch):
		selected.emit(index)
		

func _on_selected(index):
	if (self.index == index):
		$".".add_theme_stylebox_override("choosed", choosedStyle)
	else:
		$".".add_theme_stylebox_override("unchoosen", unchoosenStyle)
