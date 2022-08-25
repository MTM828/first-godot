extends Button

func unpause():
	get_parent().hide()
	get_parent().get_parent().get_node("PauseButton").show()
	get_tree().paused = false
