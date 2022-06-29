shader_type canvas_item;

uniform sampler2D p; // Pressure
uniform sampler2D w; // Intermediate velocity

void fragment(){

	float x0 = texture(p, UV - vec2(1, 0) * SCREEN_PIXEL_SIZE).x;
	float x1 = texture(p, UV + vec2(1, 0) * SCREEN_PIXEL_SIZE).x;
	float y0 = texture(p, UV - vec2(0, 1) * SCREEN_PIXEL_SIZE).x;
	float y1 = texture(p, UV + vec2(0, 1) * SCREEN_PIXEL_SIZE).x;

	// New velocity
	vec2 pressureGradient = (vec2(x1, y1) - vec2(x0, y0));
	vec2 oldV = texture(w, UV).xy;
	
	// Check for obstacles
	if (texture(w, UV).b > 0.0){
		COLOR = vec4(0.0, 0.0, 1.0, 1.0);
	} else {
		COLOR = vec4((oldV - pressureGradient), 0.0, 1.0);
	}

}