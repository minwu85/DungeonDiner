extends Node2D

func _ready():
	pass


func _process(delta):
	change_scene()


func _on_outside_restaurant_transition_point_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene = true


func _on_outside_restaurant_transition_point_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene = false

func change_scene():
	if global.transition_scene == true;
	if global.current_scene == "outside_restaurant":
		get_tree().change_scene_to_file("res://scences/outside_restaurant.tscn")
		global.finish_changescenes()
