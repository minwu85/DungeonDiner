extends CharacterBody2D

enum PlayerState {
	collect_down, collect_side, collect_up,
	death_down, death_side, death_up,
	hit_down, hit_side, hit_up,
	idle_down, idle_side, idle_up,
	run_down, run_side, run_up,
	slice_down, slice_side, slice_up,
	walk_down, walk_side, walk_up
}

var enemy_inattack_range=false
var enemy_attack_cooldown =true
var player_alive=true
var attack_ip=false
var is_collecting = false

var health=100
var gold=0
var walk_speed = 1.0
var run_speed = 2.0
var movement_type = 1  # 1 for walk, 2 for run (used by play_anim)

const speed = 100
var current_dir = "none"

@onready var animPlayer=$AnimatedSprite2D

func _ready():
	animPlayer.play("idle_down")

func _physics_process(delta):

	if player_alive:
		player_movement(delta)
		enemy_attack()
		attack()
		current_camera()

		if health <= 0:#check player health variable 
			health = 0
			player_death()#call deaht animation 
			
func player_death():#death animtion for death then directed to menu
	player_alive = false
	print("player has been killed")
	match current_dir:
		"right":
			animPlayer.play("death_side")
		"left":
			animPlayer.play("death_side")
		"down":
			animPlayer.play("death_down")
		"up":
			animPlayer.play("death_up")
	await animPlayer.animation_finished
	self.queue_free()
	get_tree().change_scene_to_file("res://scences/start_menu.tscn")


	
func player_movement(delta):
	var speed_multiplier = walk_speed  # default to walking
	
	#this set the speed for run 
	if Input.is_action_pressed("run"): 
		movement_type = 2
		speed_multiplier = run_speed 
	else:
		movement_type = 1
		speed_multiplier = walk_speed

	if player_alive and Input.is_action_pressed("slice") and not attack_ip:
		slice_state()

	
	#player movement action
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("move_right"):
		current_dir = "right"
		play_anim(movement_type)
		velocity.x = speed * speed_multiplier
		velocity.y = 0
		#print("you are: ", speed_multiplier) #test player speed
	elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("move_left"):
		current_dir = "left"
		play_anim(movement_type)
		velocity.x = -speed * speed_multiplier
		velocity.y = 0
	elif Input.is_action_pressed("ui_down") or Input.is_action_pressed("move_down"):
		current_dir = "down"
		play_anim(movement_type)
		velocity.y = speed * speed_multiplier
		velocity.x = 0
	elif Input.is_action_pressed("ui_up") or Input.is_action_pressed("move_up"):
		current_dir = "up"
		play_anim(movement_type)
		velocity.y = -speed * speed_multiplier
		velocity.x = 0
	else:
		play_anim(0)
		velocity = Vector2.ZERO

	move_and_slide()


func play_anim(movement):#play movement animation 
	var dir=current_dir
	
	if dir == "right":
		animPlayer.flip_h=false
		if movement == 1:
			animPlayer.play("walk_side")
		elif movement==2:
			animPlayer.play("run_side")		
		elif movement == 0:
			if attack_ip == false:
				animPlayer.play("idle_side")
	if dir == "left":
		animPlayer.flip_h=true
		if movement == 1:
			animPlayer.play("walk_side")
		elif movement==2:
			animPlayer.play("run_side")	
		elif movement == 0:
			if attack_ip == false:
				animPlayer.play("idle_side")
	if dir == "down":
		animPlayer.flip_h=true
		if movement == 1:
			animPlayer.play("walk_down")
		elif movement==2:
			animPlayer.play("run_down")	
		elif movement == 0:
			if attack_ip == false:
				animPlayer.play("idle_down")
	if dir == "up":
		animPlayer.flip_h=true
		if movement == 1:
			animPlayer.play("walk_up")
		elif movement==2:
			animPlayer.play("run_up")	
		elif movement == 0:
			if attack_ip == false:
				animPlayer.play("idle_up")
		
	if is_collecting:#player collected animation 
		return
		
func player():
	pass

func _on_player_hitbox_body_entered(body):#player detected attack
	if body.has_method("enemy"):
		enemy_inattack_range=true
		
func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range=false
		
func enemy_attack():
	if not player_alive:
		return
	if enemy_inattack_range and enemy_attack_cooldown:
		health -= 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print("Player Health:", health)

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown=true

func attack():#player attack animation 
	var dir = current_dir

	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_ip = true
		if dir == "right":
			animPlayer.flip_h = false
			animPlayer.play("hit_side")
			$deal_attack_timer.start()
		elif dir == "left":
			animPlayer.flip_h = true
			animPlayer.play("hit_side")
			$deal_attack_timer.start()
		elif dir == "down":
			animPlayer.play("hit_down")
			$deal_attack_timer.start()
		elif dir == "up":
			animPlayer.play("hit_up")
			$deal_attack_timer.start()

	
func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	global.player_current_attack=false
	attack_ip=false
	
func collect_state():
	if is_collecting:
		return
	is_collecting = true
	match current_dir:
		"right", "left":
			animPlayer.flip_h = (current_dir == "left")
			animPlayer.play("collect_side")
		"down":
			animPlayer.flip_h = false
			animPlayer.play("collect_down")
		"up":
			animPlayer.flip_h = false
			animPlayer.play("collect_up")
	await get_tree().create_timer(0.5).timeout  # adjust duration to match your animation
	is_collecting = false
	print("Item collected")

func slice_state():
	attack_ip = true  # prevent reentry
	match current_dir:
		"right", "left":
			animPlayer.flip_h = (current_dir == "left")
			animPlayer.play("slice_side")
		"down":
			animPlayer.flip_h = false
			animPlayer.play("slice_down")
		"up":
			animPlayer.flip_h = false
			animPlayer.play("slice_up")
	await animPlayer.animation_finished
	print("player slice hit, damage x2")
	attack_ip = false  # re-enable attack


func current_camera():#camera control
	if global.current_scene=="world":
		$world_camera.enabled=true
		$cliffside_camera.enabled=false
	elif global.current_scene=="cliff_side":
			$world_camera.enabled=false
			$cliffside_camera.enabled=true
