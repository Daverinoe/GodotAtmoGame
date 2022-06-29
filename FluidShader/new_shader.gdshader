shader_type canvas_item;

uniform sampler2D w; // Intermediate velocity (full of divergence)

void fragment(){
	vec4 wL;
	vec4 wR;
	// CONSIDER BOUNDARY CONDITIONS
	if (UV.x < SCREEN_PIXEL_SIZE.x) {
		wL = texture(w, 1.0/SCREEN_PIXEL_SIZE.x - vec2(1.0, 0.0) * SCREEN_PIXEL_SIZE);
	} else {
		wL = texture(w, UV - vec2(1.0, 0.0) * SCREEN_PIXEL_SIZE);
	}
	if (UV.x > 1.0/SCREEN_PIXEL_SIZE.x - SCREEN_PIXEL_SIZE.x) {
		wR = texture(w, vec2(1.0, 0.0) * SCREEN_PIXEL_SIZE);
	} else {
		wR = texture(w, UV + vec2(1.0, 0.0) * SCREEN_PIXEL_SIZE);
	}
	
	vec4 wB = texture(w, UV - vec2(0.0, 1.0) * SCREEN_PIXEL_SIZE);
	vec4 wT = texture(w, UV + vec2(0.0, 1.0) * SCREEN_PIXEL_SIZE);

	float divergence = (wR.x - wL.x + wT.y - wB.y) * 0.5;
//	COLOR = vec4(divergence) * 0.5 + 0.5;
	// Is there an obstacle?
	if(texture(w, UV).z > 0.0){
		COLOR = vec4(vec2(0.0), 0.0, 1.0);
	} else {
		COLOR = vec4(vec2(divergence), 0.0, 1.0);
	}
}