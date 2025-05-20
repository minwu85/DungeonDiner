extends CharacterBody2D

var speed = 40 # Enemy movement speed
var player_chase = false # Whether the enemy should chase the player
var player = null # Reference to the player node

# Enemy health and status flags
var health = 50
var player_inattack_zone = false
var can_take_damage = true
var alive = true

func _physics_process(delta):
	handle_damage()  # Check for normal attack damage

	if alive:
		if player_chase and player != null: # Move toward the player
			position += (player.position - position).normalized() * speed * delta
			move_and_collide(Vector2(0, 0))  # Simple collision handling
			$AnimatedSprite2D.play("ske_run")  # Play run animation
			$AnimatedSprite2D.flip_h = (player.position.x - position.x) < 0 # Flip sprite to face player
		else:
			$AnimatedSprite2D.play("ske_idle") # Idle animation when not chasing
		
		move_and_slide()

# Player enters detection area
func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		player_chase = true

# Player exits detection area
func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		player_chase = false

# Empty placeholder function
func enemy():
	pass

# Player enters enemy's attack zone
func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone = true

# Player exits enemy's attack zone
func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_zone = false

# Make this match what player is calling
func receive_damage(damage: int):
	if not alive:
		return
	health -= damage
	print("skeleton health =", health)  # Show skeleton health even when sliced
	if health <= 0:
		health = 0
		alive = false
		$AnimatedSprite2D.play("ske_death")
		await $AnimatedSprite2D.animation_finished
		queue_free()

# Used only for regular attack (not slice)
func handle_damage():
	if player_inattack_zone and global.player_current_attack == true and can_take_damage:
		receive_damage(10)
		can_take_damage = false
		$take_damage_cooldown.start()

func _on_take_damage_cooldown_timeout():
	can_take_damage = true
