extends Node2D

func _process(delta):
	change_scene()

func _on_cliffside_exitpoint_body_entered(body):
	if body.has_method("player"):
		global.transition_scene=true
		

func change_scene():
	if global.transition_scene==true:
		if global.current_scene == "cliff_side":
			get_tree().change_scene_to_file("res://scences/world.tscn")
			global.finish_changescenes() 
		
		print("Trying to change from", global.current_scene)
