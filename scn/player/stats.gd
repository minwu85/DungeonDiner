extends CanvasLayer

@onready var health_bar = $HealthBar
@onready var stamina_bar = $stamina

var max_playerhealth =100

var stamina=50
var stamina_cost
var attack_cost=10
var slice_cost=20
var run_cost=5

var player_health:
	set(value):
		player_health =value
		health_bar.value=player_health
func _ready() -> void:
	player_health=max_playerhealth
	health_bar.max_value = max_playerhealth
	health_bar.value = health_bar.max_value

func _process(delta: float) -> void:
	stamina_bar.value=stamina
	if stamina<100:
		stamina+=10*delta
		
func stamina_consumption():
	stamina -= stamina_cost
	print("Stamina reduced by", stamina_cost, "Remaining:", stamina)
