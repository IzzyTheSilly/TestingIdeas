shader_type canvas_item;

uniform bool active;

void fragment() {
	vec4 original_color = texture(TEXTURE, UV);
	vec4 white_color = vec4(1.0, 1.0, 1.0, original_color.a);
	vec4 new_color = original_color;
	if (active) {
		new_color = white_color;
	}
	COLOR = new_color;
}
