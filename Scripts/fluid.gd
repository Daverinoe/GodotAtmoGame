tool
extends TextureRect


export(float) var timestep = 1.0;
export(float) var radius = 1500.0;


var mouse_pos = Vector2()
var last_mouse_pos = Vector2()
var brushType = "obstacle";

var clearmodeSet = false;


func _init():
	for child in get_children():
		child.size = rect_size


func _process(delta):
	mouse_pos = get_local_mouse_position()
	setAdvectionParameters(delta)
	changeTimeOfDay(delta)
	last_mouse_pos = mouse_pos
	

func _input(event):
	if (Input.is_mouse_button_pressed(1) or Input.is_mouse_button_pressed(2)) and event is InputEventMouseMotion:
		match brushType:
			"velocity":
				addVelocitySplat()
			"obstacle":
				addObstacleSplat()
			"ink":
				addInkSplat()

func changeTimeOfDay(delta):
	var temperature = get_node("Temperature/temperature").material
	temperature.set_shader_param("timestep", delta)

func setAdvectionParameters(delta):
	var velocity = get_node("Advection(u)/velocity").material
	var density = get_node("Ink/ink").material
	velocity.set_shader_param("timestep", timestep * 60 * delta)
	density.set_shader_param("timestep", timestep * 60 * delta)

func addVelocitySplat():
	var addVelocity = get_node("AddForces(u)/velocitySplat").material
	
	addVelocity.set_shader_param("point", mouse_pos)
	
	var delta_mouse = mouse_pos - last_mouse_pos
	var mouse_color = (delta_mouse.normalized()*0.5 + Vector2(0.5, 0.5))
	
	if delta_mouse.length() > 0:
		addVelocity.set_shader_param("color", Color(mouse_color.x, mouse_color.y, 0.0))
		
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		addVelocity.set_shader_param("radius", radius)
	else:
		addVelocity.set_shader_param("radius", 0.0)

func addObstacleSplat():
	if !clearmodeSet:
		get_node("Obstacles").set_clear_mode(1)
		clearmodeSet = true
	var addObstacle = get_node("Obstacles/addObstacles").material
	
	addObstacle.set_shader_param("point", mouse_pos)
	
	var delta_mouse = mouse_pos - last_mouse_pos
	
	if delta_mouse.length() > 0:
		addObstacle.set_shader_param("color", Color(1.0, 1.0, 1.0))
		
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		addObstacle.set_shader_param("radius", radius)
	else:
		addObstacle.set_shader_param("radius", 0.0)

func addInkSplat():
	var addInk = get_node("Ink/addInk").material
	
	addInk.set_shader_param("point", mouse_pos)
	
	var delta_mouse = mouse_pos - last_mouse_pos
	
	if delta_mouse.length() > 0:
		addInk.set_shader_param("color", Color(0.0, 0.0, 0.0))
		
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		addInk.set_shader_param("radius", radius)
	else:
		addInk.set_shader_param("radius", 0.0)
