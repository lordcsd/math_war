extends Control


func _ready():
	pass

func _on_back_pressed():
	get_tree().change_scene("res://scenes/home.tscn")

func _on_onePlayer_pressed():
	get_tree().change_scene("res://scenes/onePlayer.tscn")
