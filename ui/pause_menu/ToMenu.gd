extends Button

func to_main_menu():
	get_tree().get_root().get_node("Main").get_node("LevelLoader").exit()
	get_tree().get_root().get_node("Main").get_node("MainMenu").show()
	get_parent().hide()
	get_tree().paused = false
