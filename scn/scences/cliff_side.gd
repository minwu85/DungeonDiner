extends Node2D

@onready var time_light = $cliff_side_light/sun
@onready var point_light = $cliff_side_light/PointLight2D
@onready var day_night_timer = $cliff_side_light/day_night
@onready var day_text = $CanvasLayer/Day
@onready var day_anim = $CanvasLayer/AnimationPlayer
@onready var health_bar = $CanvasLayer/HealthBar

enum TimeState {
	MORNING,
	EVENING
}

var state_time = TimeState.MORNING
var day_count: int

func _ready():
	# light control
	time_light.enabled = true
	point_light.enabled = true
	
	if day_night_timer:
		day_night_timer.start()
	global.apply_light_state(time_light, point_light)
	set_day_ui()

	# day count init
	day_count = 1
	#set_day_text()
	#day_text_fade()
	
	# health bar display 
	health_bar.value = global.player_health

func _process(delta):
	change_scene()

func _on_cliffside_exitpoint_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true

func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "cliff_side":
			get_tree().change_scene_to_file("res://scn/scences/world.tscn")
			global.finish_changescenes()
		print("Trying to change from", global.current_scene)

func set_day_ui():
	day_text.text = "Day " + str(global.day_count)
	day_anim.play("day_fade_in")
	await get_tree().create_timer(3).timeout
	day_anim.play("day_fade_out")


func day_text_fade():
	if day_anim:
		day_anim.play("day_fade_in")
		await get_tree().create_timer(3).timeout
		day_anim.play("day_fade_out")
