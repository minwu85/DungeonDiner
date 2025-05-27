extends Panel

var default_tex = preload("res://art/art2/UI/basebrownrect.png")
var empty_tex = preload("res://art/art2/UI/basebrownrect.png")

var default_style: StyleBoxTexture
var empty_style: StyleBoxTexture

var ItemClass = preload("res://scn/weapon/item.tscn")
var item: Node2D = null

func _ready():
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	default_style.texture = default_tex
	empty_style.texture = empty_tex

	if randi() % 2 == 0:
		item = ItemClass.instantiate()
		item.position = Vector2.ZERO
		add_child(item)

	refresh_style()

func refresh_style():

	if item == null:
		set("theme_override_styles/panel", empty_style)
	else:
		set("theme_override_styles/panel", default_style)

func pick_from_slot() -> Node2D:
	var temp = item
	if item:
		remove_child(item)  # We can safely do this since we are the parent
		item = null
		refresh_style()
	return temp

func put_into_slot(new_item: Node2D):
	item = new_item
	item.position = Vector2.ZERO
	add_child(item)  # We assume item is already removed from any previous parent
	refresh_style()
