shader_type spatial;
uniform vec3 ground_colour : source_color;
uniform sampler2D ground_noise_normal;

void fragment() {

	ALBEDO = ground_colour; 
	NORMAL_MAP = texture(ground_noise_normal, UV).rgb;
}

