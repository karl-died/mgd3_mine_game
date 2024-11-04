shader_type canvas_item;

uniform sampler2D noise;

uniform float noise_amount = 0.5;

void fragment() {
	vec4 col = texture(TEXTURE, UV);
	float noise_val = texture(noise, UV).r;
	col.rgb *= (1.0 - noise_amount) + noise_val * noise_amount;
	COLOR = col;
}

