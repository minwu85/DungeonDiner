extends Node2D


func _ready( ):
	if randi() % 2 == 0:
		$TextureReact.texture = load("res://art/Weapons/Wood/wood_sword.png")
	else:
		$TextureReact.texture = load("res://art/Weapons/Wood/wood_axe.png")
