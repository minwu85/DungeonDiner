extends Node2D

@onready var time_light = $DirectionalLight2D
@onready var day_night_timer = $day_night

enum TimeState {
	MORNING,
	EVENING
}

var state_time = TimeState.MORNING

func _ready():
	time_light.enabled = true
	if day_night_timer:
		day_night_timer.wait_time = 5.0
		day_night_timer.start()
	set_light_state()

func _process(delta):
	change_scene() #call scence change
	
func _on_cliffside_exitpoint_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true

func change_scene():#change scence
	if global.transition_scene == true:
		if global.current_scene == "cliff_side":
			get_tree().change_scene_to_file("res://scences/world.tscn")
			global.finish_changescenes()
		print("Trying to change from", global.current_scene)

func _on_day_night_timeout() -> void:#count down on light change
	if state_time == TimeState.MORNING:
		state_time = TimeState.EVENING
	else:
		state_time = TimeState.MORNING
	set_light_state()
	
func set_light_state():):#light change depeneds on energy 
	var tween = get_tree().create_tween()
	match state_time:
		TimeState.MORNING:
			tween.tween_property(time_light, "energy", 0.1, 5)
			print("now is morning")
		TimeState.EVENING:
			tween.tween_property(time_light, "energy", 0.9, 5)
			print("now is night")
