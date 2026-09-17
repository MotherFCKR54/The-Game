extends Node2D

var fiok_scene = preload("res://scenes/fiók.tscn")

func fioknyitas():
	var fiok = fiok_scene.instantiate()
	add_child(fiok)
