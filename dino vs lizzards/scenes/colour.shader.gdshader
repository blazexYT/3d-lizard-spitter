shader_type spatial;

uniform sampler2D colour_shader;

uniform float min_height = 0;
uniform float max_height = 1;

varying float vertex_y;

float inversLerp(float a, float b, float value){
	float val = (value - a)  / (b - a);
	return clamp(0.01,1.0,val);
	
}
	

void fragment() {
	float height = vertex_y;
	float position = inversLerp(min_height,max_height,height);
	vec3 colour = texture(colour_shader,vec2(position,0)).rgb;
	ALBEDO = colour;
}
void vertex(){
	vertex_y = VERTEX.y;
	
	
	
	
}
//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
