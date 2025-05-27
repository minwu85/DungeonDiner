extends Node2D

@onready var time_light = $cliff_side_light/sun #call light change
@onready var point_light = $cliff_side_light/PointLight2D #call light shine in play/shop
@onready var day_night_timer = $cliff_side_light/day_night #call count down 
@onready var day_text = $CanvasLayer/Day #call day text
@onready var day_anim = $CanvasLayer/AnimationPlayer #call day text anim

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

	set_light_state()

	# day count init
	day_count = 1
	set_day_text()
	day_text_fade()

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

func _on_day_night_timeout() -> void:
	if state_time == TimeState.MORNING:
		state_time = TimeState.EVENING
	else:
		state_time = TimeState.MORNING
	set_light_state()

func set_light_state():
	# Create tweens
	var tween = get_tree().create_tween()
	var tween1 = get_tree().create_tween()

	match state_time:
		TimeState.MORNING:
			if time_light:
				tween.tween_property(time_light, "energy", 0.1, 20)
			if point_light:
				tween1.tween_property(point_light, "energy", 0, 20)
			print("now is morning")

		TimeState.EVENING:
			if time_light:
				tween.tween_property(time_light, "energy", 1, 20)
			if point_light:
				tween1.tween_property(point_light, "energy", 1.5, 20)
			day_count += 1
			set_day_text()
			day_text_fade()
			print("now is night")

func set_day_text():
	if day_text:
		day_text.text = "Day " + str(day_count)

func day_text_fade():
	if day_anim:
		day_anim.play("day_fade_in")
		await get_tree().create_timer(3).timeout
		day_anim.play("day_fade_out")
