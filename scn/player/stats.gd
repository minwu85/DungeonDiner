extends CanvasLayer

@onready var health_bar = $HealthBar

var max_player_health := 1000
var _player_health := max_player_health

var player_health:
	get: return _player_health
	set(value):
		_player_health = clamp(value, 0, max_player_health)
		if health_bar:
			health_bar.value = _player_health

func _ready() -> void:
	if health_bar:
		health_bar.max_value = max_player_health
		health_bar.value = _player_health

# Optional function to apply damage
func apply_damage(amount: int) -> void:
	player_health -= amount

# Optional function to heal
func heal(amount: int) -> void:
	player_health += amount
