extends Node2D


# 播放 UI 点击音效
@onready var click_audio_player = $UIClick

# 播放音符点击音效
@onready var hit_audio_player = $Hit


func set_volume(volume):
	click_audio_player.volume_db = linear_to_db(volume * 0.01)
	hit_audio_player.volume_db = linear_to_db(volume * 0.01)


func play_click_audio():
	click_audio_player.play(0.0)


func play_hit_audio():
	hit_audio_player.play(0.0)


# 将拍子计算为 y 坐标
func sec_to_length(sec):
	return 185 - 10 * 60 * ((sec) * 60 / GlobalSystem.bpm + GlobalSystem.dt + GlobalSystem.saved_adjustment)
