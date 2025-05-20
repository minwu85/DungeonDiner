extends Node2D

@onready var time_light = $light/sun #call light change
#@onready var point_light = #call light shine in play/shop
@onready var day_night_timer = $light/day_night #call count down 
@onready var day_text=$CanvasLayer/Day #call day text
@onready var day_anim=$CanvasLayer/AnimationPlayer #call day text anim
@onready var health_bar=$CanvasLayer/HealthBar #call healthbar display 
@onready var player=$player/player #call player

enum TimeState {
	MORNING,
	EVENING
}

var state_time = TimeState.MORNING
var day_count: int

func _ready():
	
	##player position 
	if global.game_first_loadin == true:#player first position set 
		$player/player.position.x = global.player_start_posx
		$player/player.position.y = global.player_start_posy
	else:#player position set change after first scence change
		$player/player.position.x = global.player_exit_cliffside_posx
		$player/player.position.y = global.player_exit_cliffside_posy
	
	##light change control
	if day_night_timer:
		day_night_timer.start()
	global.apply_light_state(time_light)
	set_day_ui()
	
	#day count
	day_count=1
	#set_day_text()#call display day text
	day_text_fade()#call display day anim
	
	##display player health bar
	health_bar.value=global.player_health
	#health_bar.max_value=player.max_health
	#health_bar.value=health_bar.max_value
	
func _process(delta):
	change_scene()#call change scence

func _on_cliffside_transition_point_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true

func change_scene():#function for scence change 
	if global.transition_scene == true:
		if global.current_scene == "world":
			get_tree().change_scene_to_file("res://scn/scences/cliff_side.tscn")#cliff_side
			global.game_first_loadin = false
			global.finish_changescenes()

func set_day_ui():
	day_text.text = "Day " + str(global.day_count)
	day_anim.play("day_fade_in")
	await get_tree().create_timer(3).timeout
	day_anim.play("day_fade_out")
#func _on_day_night_timeout() -> void: #count down light change 
#	if state_time == TimeState.MORNING:
#		state_time = TimeState.EVENING
#	else:
#		state_time = TimeState.MORNING
#	set_light_state()

#func set_light_state():#light change depeneds on energy 
#	var tween = get_tree().create_tween() #for the change in morn to night
#	var tween1 = get_tree().create_tween() #for player not shin in morn
#	match state_time:
#		TimeState.MORNING:
#			#([call light], [energy of light], [dark], [timer])
#			tween.tween_property(time_light, "energy", 0.1, 20)
#			#tween1.tween_property(point_light, "energy", 0, 5) #for player not shin in morn
#			print("now is morning")#test is morning
#		TimeState.EVENING:
#			tween.tween_property(time_light, "energy", 1, 20)
#			#tween1.tween_property(point_light, "energy", 1.5, 5) #for player not shin in morn
#			day_count+=1
#			set_day_text()#call display day text
#			day_text_fade()#call display day anim
#			print("now is night")#test is night
#
#func set_day_text():
#	day_text.text="Day "+str(day_count)

func day_text_fade():
	day_anim.play("day_fade_in")
	await get_tree().create_timer(3).timeout #stop of 3sec
	day_anim.play("day_fade_out")

func _on_player_health_change_bar(new_health: Variant) -> void:
	health_bar.value=global.player_health
