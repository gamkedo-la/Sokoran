extends Node2D


func _ready():
	Global.current_scene = self
	Global.goto_scene("res://scenes/MenuScene.tscn")

