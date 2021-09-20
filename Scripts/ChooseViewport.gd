extends MenuButton

var popup

# Get viewport material so we can choose which view to look at later
var ViewingMaterial 

# Called when the node enters the scene tree for the first time.
func _ready():
	ViewingMaterial = get_node("/root/Canvas/fluid/Viewing/Viewing").material
	popup = get_popup()
		
	# Grab all the viewports and make popups for them (if we want them)
	popup.add_item("Obstacles")
	popup.add_item("Ink")
	popup.add_item("Temperature")
	popup.add_item("Divergence")
	popup.add_item("Pressure")
	popup.add_item("Velocity")
	popup.connect("id_pressed", self, "_on_item_pressed")

func _on_item_pressed(ID):
	match ID:
		0:
			ViewingMaterial.set_shader_param("viewport", 2)
		1:
			ViewingMaterial.set_shader_param("viewport", 5)
		2:
			ViewingMaterial.set_shader_param("viewport", 1)
		3:
			ViewingMaterial.set_shader_param("viewport", 3)
		4:
			ViewingMaterial.set_shader_param("viewport", 4)
		5:
			ViewingMaterial.set_shader_param("viewport", 0)
