extends Node2D

@onready var time_light = $DirectionalLight2D
@onready var day_night_timer = $day_night

enum TimeState {
	MORNING,
	EVENING
}

var state_time = TimeState.MORNING

func _ready():
	if global.game_first_loadin == true:#player first position set 
		$player.position.x = global.player_start_posx
		$player.position.y = global.player_start_posy
	else:#player position set change after first scence change
		$player.position.x = global.player_exit_cliffside_posx
		$player.position.y = global.player_exit_cliffside_posy
	
	#light change control
	time_light.enabled = true
	if day_night_timer:
		day_night_timer.wait_time = 5.0
		day_night_timer.start()
	set_light_state()

func _process(delta):
	change_scene()#call change scence

func _on_cliffside_transition_point_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true

func change_scene():#function for scence change 
	if global.transition_scene == true:
		if global.current_scene == "world":
			get_tree().change_scene_to_file("res://scences/cliff_side.tscn")
			global.game_first_loadin = false
			global.finish_changescenes()

func _on_day_night_timeout() -> void: #count down light change 
	if state_time == TimeState.MORNING:
		state_time = TimeState.EVENING
	else:
		state_time = TimeState.MORNING
	set_light_state()

func set_light_state():#light change depeneds on energy 
	var tween = get_tree().create_tween()
	match state_time:
		TimeState.MORNING:
			tween.tween_property(time_light, "energy", 0.1, 5)
			print("now is morning")
		TimeState.EVENING:
			tween.tween_property(time_light, "energy", 0.9, 5)
			print("now is night")
