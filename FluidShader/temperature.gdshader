shader_type canvas_item;

const float PI = 3.14159265;

void fragment(){
	// Earth is approx. 0.005 degrees per km temp difference.
	float yTempchange = 0.005 / SCREEN_PIXEL_SIZE.y;
	float xTempchange = 0.005 / SCREEN_PIXEL_SIZE.x;
	vec4 TempGradient = vec4((sin(UV.y * PI) * yTempchange + cos(UV.x * PI - PI / 2.0 * TIME / 10.0) * xTempchange), 0.0, 0.0, 1.0);
	
	COLOR = TempGradient;
}