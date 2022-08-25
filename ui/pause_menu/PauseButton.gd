extends Button

func pause():
	hide()
	get_parent().get_node("PauseScreen").show()
	get_tree().paused = true
