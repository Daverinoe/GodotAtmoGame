shader_type canvas_item;

uniform sampler2D divw; // Divergence of intermediate velocity

float samplePressure(vec2 pos, vec2 border, sampler2D p)
{    
	// Is there an obstacle?
	if(texture(divw, pos).z > 0.0){
		return 0.0;
	}
	
	if(pos.x > 1.0 - border.x){ // Right border
		return texture(p, vec2(border.x, pos.y)).x;
	
	} else if (pos.x < border.x){ // Left border
		return texture(p, vec2(1.0/border.x, pos.y)).x;
		
	} else if (pos.y > 1.0 - border.y){
		return texture(p, pos - border * vec2(0.0, 1.0)).x;
		
	}  else if (pos.y < border.y){
		return texture(p, pos + border * vec2(0.0, 1.0)).x;
		
	}else {
		return texture(p, pos).x;
		
	}
}

void fragment(){

	float alpha = -1.0;
	float rbeta = 0.25;

    vec2 border = SCREEN_PIXEL_SIZE;

    float div = texture(divw, UV).x;
    float x0 = samplePressure(SCREEN_UV - vec2(1, 0) * SCREEN_PIXEL_SIZE, border, SCREEN_TEXTURE);
    float x1 = samplePressure(SCREEN_UV + vec2(1, 0) * SCREEN_PIXEL_SIZE, border, SCREEN_TEXTURE);
    float y0 = samplePressure(SCREEN_UV - vec2(0, 1) * SCREEN_PIXEL_SIZE, border, SCREEN_TEXTURE);
    float y1 = samplePressure(SCREEN_UV + vec2(0, 1) * SCREEN_PIXEL_SIZE, border, SCREEN_TEXTURE);

   	COLOR = vec4(vec2(((x0 + x1 + y0 + y1 + (alpha * div)) * rbeta)), 0.0, 1.0);
} 