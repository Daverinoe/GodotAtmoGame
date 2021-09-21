extends HSlider

var counter = 0
var children

# Called when the node enters the scene tree for the first time.
func _ready():
	children = get_node("/root/Canvas/fluid/computePressure").get_children()
	for child in children:
		counter += 1
	self.max_value = counter


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HSlider_value_changed(value):
	if !children[value-1].visible:
		children[value-1].visible = true
		return
	children[value-1].visible = false
