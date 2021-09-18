shader_type canvas_item;

uniform vec4 color : hint_color;
uniform vec2 point;
uniform float radius;

uniform sampler2D tempVelocity;

float gauss(vec2 p, float r)
{
    return exp(-dot(p, p) / r);
}


void fragment()
{
    vec3 base = texture(tempVelocity, UV).rgb;
    vec2 coord = point * SCREEN_PIXEL_SIZE - UV;
    float splat = gauss(coord / SCREEN_PIXEL_SIZE, radius);
	if (base.z > 0.0) {
		COLOR.rgb = base;
	} else {
		COLOR = vec4(mix(base.rg, color.rg, splat), 0.0, 1.0);
	}
    
}