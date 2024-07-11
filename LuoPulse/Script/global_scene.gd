extends Node2D

@onready var click_audio_player = $UIClick

@onready var hit_audio_player = $Hit

func set_volume(volume):
	click_audio_player.volume_db = linear_to_db(volume * 0.01)
	hit_audio_player.volume_db = linear_to_db(volume * 0.01)
	
func play_click_audio():
	click_audio_player.play(0.0)

func play_hit_audio():
	hit_audio_player.play(0.0)
	
func sec_to_length(sec):
	return 185 - 10 * 60 * ((sec) * 60 / GlobalSystem.bpm + GlobalSystem.dt + GlobalSystem.saved_adjustment)
	
