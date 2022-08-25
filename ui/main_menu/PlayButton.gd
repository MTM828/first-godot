extends Button

func play():
	get_parent().get_parent().get_node("LevelLoader").start()
	get_parent().get_parent().get_node("PauseMenu").get_node("UI").get_node("PauseButton").show()
	get_parent().hide()
