shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec2 center;
uniform float force;
uniform float size;
uniform float thickness;

void fragment() {
	float ratio = TEXTURE_PIXEL_SIZE.x / TEXTURE_PIXEL_SIZE.y;
	vec2 norm_uv = (UV - vec2(0.5, 0.0)) / vec2(ratio, 1.0) + vec2(0.5, 0.0);
	float adjusted_thickness = thickness * 0.001;
	float mask = (1.0 - smoothstep(size - 0.03, size - adjusted_thickness, length(norm_uv - center))) *
			smoothstep(size - adjusted_thickness - 0.03, size - adjusted_thickness, length(norm_uv -center));

	vec2 disp = normalize(norm_uv - center) * force * mask;
	vec4 col = texture(screen_texture, SCREEN_UV - disp);
	COLOR = col;
}
