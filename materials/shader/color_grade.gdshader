shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	vec4 col = texture(screen_texture, SCREEN_UV);
	float bw = length(col.rgb);
	float desat_amount = 0.3;
	col.rgb = desat_amount * vec3(bw) + (1.0 - desat_amount) * col.rgb;

	col.r = pow(col.r, 1.3);
	col.g = pow(col.g, 1.7);
	col.b = pow(col.b, 1.5);
	
	col.r *= 1.3;
	col.r -= 0.04;
	col.g *= 1.5;
	col.g -= 0.01;
	col.rgb *= 1.7;
	float gamma = 1.1;
	col.r = pow(col.r, gamma);
	col.g = pow(col.g, gamma);
	col.b = pow(col.b, gamma);
	COLOR = col;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
