shader_type canvas_item;

uniform sampler2D health_bar_texture;
uniform float health_ratio: hint_range(0, 1);
uniform sampler2D noise_texture;
uniform float shake_speed;
uniform float shake_amplitude;
uniform bool is_flashing;
uniform vec4 flash_color: source_color;
uniform float flash_speed;
uniform vec4 border_color: source_color;
uniform float border_size;
uniform float x_to_y_ratio;

void vertex() {
	float offset_x = (texture(noise_texture, vec2(0, fract(TIME * shake_speed))).x - 0.5) * shake_amplitude;
	float offset_y = (texture(noise_texture, vec2(fract(TIME * shake_speed), 0)).x - 0.5) * shake_amplitude * x_to_y_ratio;
	VERTEX += vec2(offset_x, offset_y);
}

void fragment() {
	vec2 coords = UV;
	coords.x *= x_to_y_ratio;
	if (distance(coords, vec2(clamp(coords.x, 0.5, x_to_y_ratio - 0.5), 0.5)) > 0.5) {
		discard;
	}
	
	vec4 new_color = texture(health_bar_texture, vec2(health_ratio * 1.4 - 0.2, UV.y));
	if (UV.x < health_ratio) {
		COLOR = new_color;
		
		if (is_flashing) {
			COLOR = vec4(vec3(new_color.rgb) * (abs(sin(TIME * flash_speed)) + 0.7), 1);
		}
	}
	else {
		COLOR = vec4(0,0,0,1);
	}
	if (distance(coords, vec2(clamp(coords.x, 0.5, x_to_y_ratio - 0.5), 0.5)) > 0.42) {
		COLOR = vec4(0,0,0,1);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
