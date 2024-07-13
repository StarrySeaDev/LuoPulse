extends Area2D


# 有音符离开, 判定 missing
func _on_body_exited(body):
	# 设置 missing 标签的坐标
	$"../MissingLabel".position.x = body.position.x + 140
	# 播放淡出动画
	$"../MissingLabel/AnimationPlayer".play("fade_out")
	#missing 计数加 1
	GlobalSystem.missing_count += 1
