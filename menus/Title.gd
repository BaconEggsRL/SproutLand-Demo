extends Node2D

func _on_play_button_up():
	get_tree().change_scene_to_file("res://scenes/World.tscn")

func _on_quit_button_up():
	get_tree().quit()
