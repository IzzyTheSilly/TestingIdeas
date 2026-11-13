shader_type spatial;

void vertex() {
	
}

void fragment() {
	ALBEDO = vec3(UV.x + sin(TIME), UV.y + cos(TIME), sin(TIME) * cos(TIME));
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
