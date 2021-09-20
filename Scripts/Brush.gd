extends MenuButton

var popup

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	popup = get_popup()
	popup.add_item("Velocity")
	popup.add_item("Ink")
	popup.add_item("Obstacle")
	popup.connect("id_pressed", self, "_on_item_pressed")

func _on_item_pressed(ID):
	match ID:
		0:
			get_node("/root/Canvas/fluid").brushType = "velocity"
		1:
			get_node("/root/Canvas/fluid").brushType = "ink"
		2:
			get_node("/root/Canvas/fluid").brushType = "obstacle"
