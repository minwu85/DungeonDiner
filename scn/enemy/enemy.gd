extends CharacterBody2D

var speed = 40
var player_chase = false
var player = null

var health = 50
var player_inattack_zone = false
var can_take_damage = true
var alive = true

func _physics_process(delta):
	deal_with_damage()
	if alive:
		if player_chase and player != null:
			position += (player.position - position).normalized() * speed * delta
			move_and_collide(Vector2(0, 0))
			$AnimatedSprite2D.play("ske_run")
			$AnimatedSprite2D.flip_h = (player.position.x - position.x) < 0
		else:
			$AnimatedSprite2D.play("ske_idle")
		move_and_slide()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		player_chase = false

func enemy():
	pass

func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone = true

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_zone = false

func deal_with_damage():
	if player_inattack_zone and global.player_current_attack == true and can_take_damage:
		health -= 20
		can_take_damage = false
		$take_damage_cooldown.start()
		print("skeleton health = ", health)

		if health <= 0:
			alive = false
			health=0
			$AnimatedSprite2D.play("ske_death")
			await $AnimatedSprite2D.animation_finished
			queue_free()

func _on_take_damage_cooldown_timeout():
	can_take_damage = true
