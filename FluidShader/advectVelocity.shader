shader_type canvas_item;

uniform float timestep;

uniform sampler2D u; // Input velocity
uniform sampler2D x; // Quantity to advect
uniform sampler2D obstacles; //
uniform sampler2D T; // Temperature

// Circular barrier
const vec2 BarrierPosition = vec2(0.1, 0.5);
const float BarrierRadiusSq = 0.001;
const vec2 Force = vec2(0.0, 0.0);


vec2 bilinearInterpolation(sampler2D tex, vec2 pos, vec2 rdx){

	vec2 p = pos / rdx - 0.5;
	vec2 fraction = fract(p);
	vec2 integer = floor(p);
	
	// Define points
	vec2 p11 = vec2(0.0);
	vec2 p12 = vec2(0.0);
	vec2 p21 = vec2(0.0);
	vec2 p22 = vec2(0.0);
		
	if (pos.x > 1.0 - rdx.x) {
		// Roll-over to left side
		p11 = texture(tex, (integer + vec2(0.5, 0.5)) * rdx).xy;
		p12 = texture(tex, (integer + vec2(0.5, 1.5)) * rdx).xy;
		p21 = texture(tex, (integer * vec2(0.0, 1.0) + vec2(0.5, 0.5)) * rdx).xy;
		p22 = texture(tex, (integer * vec2(0.0, 1.0) + vec2(0.5, 1.5)) * rdx).xy;
		return vec2(0.0)
	} else if (pos.x < rdx.x) {
		// Roll-over to right side
		p11 = texture(tex, (integer + vec2(0.5, 0.5)) * rdx).xy;
		p12 = texture(tex, (integer + vec2(0.5, 1.5)) * rdx).xy;
		p21 = texture(tex, (integer + vec2((1.0/rdx.x) + 0.5, 0.5)) * rdx).xy;
		p22 = texture(tex, (integer + vec2((1.0/rdx.x) + 0.5, 1.5)) * rdx).xy;
		return vec2(1.0)
	} else {
		// Weight the points
		p11 = texture(tex, (integer + vec2(0.5, 0.5)) * rdx).xy;
		p12 = texture(tex, (integer + vec2(0.5, 1.5)) * rdx).xy;
		p21 = texture(tex, (integer + vec2(1.5, 0.5)) * rdx).xy;
		p22 = texture(tex, (integer + vec2(1.5, 1.5)) * rdx).xy;
	}
	
	return mix(mix(p11, p21, fraction.x), mix(p12, p22, fraction.x), fraction.y);
}

void fragment(){

	vec2 oldPos = UV - timestep * SCREEN_PIXEL_SIZE * (texture(u, UV).xy);
	vec2 outputVelocity = bilinearInterpolation(x, oldPos, SCREEN_PIXEL_SIZE).xy;

	// Add forces (here, horizontal force)
	if (UV.x > 0.0 && UV.x < 0.06 && UV.y > 0.2 && UV.y < 0.8)
	{
		outputVelocity += Force;
	}

	// Add temperature
	if (UV.x < 1.0 - SCREEN_PIXEL_SIZE.x && UV.y < 1.0 - SCREEN_PIXEL_SIZE.y && UV.x >  SCREEN_PIXEL_SIZE.x && UV.y > SCREEN_PIXEL_SIZE.y)
	{
		float tempPoint = texture(T, UV).r;
		float x0 = texture(T, UV - vec2(1.0, 0.0) * SCREEN_PIXEL_SIZE).r;
		float x1 = texture(T, UV + vec2(1.0, 0.0) * SCREEN_PIXEL_SIZE).r;
		float y0 = texture(T, UV - vec2(0.0, 1.0) * SCREEN_PIXEL_SIZE).r;
		float y1 = texture(T, UV + vec2(0.0, 1.0) * SCREEN_PIXEL_SIZE).r;
		float yTempGradient = -(y1 - y0) / (2.0 * SCREEN_PIXEL_SIZE.y) * 0.001;
		float xTempGradient = -(x1 - x0) / (2.0 * SCREEN_PIXEL_SIZE.x) * 0.001;
		// Add vertical velocity due to temperature
		outputVelocity.y -= yTempGradient;
		// Add horizontal velocity due to temprature
		outputVelocity.x -= xTempGradient;
	}


	// Check for obstacles -> Should be 6 cases. No obstacle surrounding, all obstacle surrounding, and the four directions.
	float checkPoint = texture(obstacles, UV).b;
	float checkTop = texture(obstacles, UV + vec2(0.0, 1.0) * SCREEN_PIXEL_SIZE).b;
	float checkBottom = texture(obstacles, UV - vec2(0.0, 1.0) * SCREEN_PIXEL_SIZE).b;
	float checkLeft = texture(obstacles, UV - vec2(1.0, 0.0) * SCREEN_PIXEL_SIZE).b;
	float checkRight = texture(obstacles, UV + vec2(1.0, 0.0) * SCREEN_PIXEL_SIZE).b;

	// Set boundary conditions on obstacles
	if ( checkTop > 0.0 && checkBottom > 0.0 && checkLeft > 0.0 && checkRight > 0.0){
		// If surrounded by obstacles, set velocity to 0.
		outputVelocity = vec2(0.0);

	} else if (checkTop > 0.0 || checkBottom > 0.0) {
		outputVelocity.y *= -1.0;

	} else if (checkLeft > 0.0 || checkRight > 0.0) {
		outputVelocity.x *= -1.0;

	}

//	// Apply boundary conditions
//	if(UV.x > 1.0 - SCREEN_PIXEL_SIZE.x){
//		outputVelocity.x = -texture(u, UV - vec2(1.0, 0.0) * SCREEN_PIXEL_SIZE).x;
//
//	} else if (UV.y > 1.0 - SCREEN_PIXEL_SIZE.y) {
//		outputVelocity.y = -texture(u, UV - vec2(0.0, 1.0) * SCREEN_PIXEL_SIZE).y;
//
//	} else if (UV.x < SCREEN_PIXEL_SIZE.x) {
//		outputVelocity.x = -texture(u, UV + vec2(1.0, 0.0) * SCREEN_PIXEL_SIZE).x;
//
//	} else if (UV.y < SCREEN_PIXEL_SIZE.y) {
//		outputVelocity.y = -texture(u, UV + vec2(0.0, 1.0) * SCREEN_PIXEL_SIZE).y;
//
//	}
	
	// Do the corners
	if (UV.x > 1.0 - SCREEN_PIXEL_SIZE.x && UV.y > 1.0 - SCREEN_PIXEL_SIZE.y){
		outputVelocity = vec2(0.0);
		
	} else if (UV.x < SCREEN_PIXEL_SIZE.x && UV.y > 1.0 - SCREEN_PIXEL_SIZE.y){
		outputVelocity = vec2(0.0);
		
	} else if (UV.x > 1.0 - SCREEN_PIXEL_SIZE.x && UV.y < SCREEN_PIXEL_SIZE.y){
		outputVelocity = vec2(0.0);
		
	} else if (UV.x < SCREEN_PIXEL_SIZE.x && UV.y < SCREEN_PIXEL_SIZE.y){
		outputVelocity = vec2(0.0);
		
	}

	// Check for obstacles
	if (checkPoint > 0.0){
		outputVelocity = vec2(0.0);
		COLOR = vec4(outputVelocity, 1.0, 1.0);
	} else {
		COLOR = vec4(outputVelocity, 0.0, 1.0);
	}
}