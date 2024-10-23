shader_type canvas_item;
render_mode light_only;

uniform sampler2D normal_map: filter_nearest;
uniform float rotation = 0;

void fragment() {
	vec3 norm = texture(normal_map, UV).rgb;
	norm.g = 1.0 - norm.g;

	float x = 2.0 * (norm.r - 0.5);
	float y = 2.0 * (norm.g - 0.5);
	
	float x_1 = x * cos(rotation) - y * sin(rotation);
	float y_1 = x * sin(rotation) + y * cos(rotation);
	
	norm.r = (x_1 / 2.0) + 0.5;
	norm.g = (y_1 / 2.0) + 0.5;
	
	//norm.b = 1.0 - norm.b;
	
	vec4 col = texture(TEXTURE, UV);
	
	//COLOR = vec4(0.4, 0.4, 0.4, col.a);
	NORMAL = norm;
	//COLOR = vec4(norm, col.a);;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
