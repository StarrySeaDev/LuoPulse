extends Node

# 全局变量

var selected_msc_cover = null

var selected_msc_title = ""

var default_msc_cover_path = "res://Resource/Img/17.png"

var default_adjustment = 0

var default_volume = 50

var default_msclist_path = "res://Resource/MscList/"

var saved_adjustment = 0

var saved_volume = 50

var saved_msclist_path = "res://Resource/MscList/"

var saved_difficulty = 1

var missing_count = 0

var perfect_count = 0

var good_count = 0

var bpm = 0

var bpp = 0

var dt = 0.0

var del = 0

var phara = 0

var is_running_note = false


func _ready():
	pass

func init():
	missing_count = 0
	perfect_count = 0
	good_count = 0
	selected_msc_title = ""
