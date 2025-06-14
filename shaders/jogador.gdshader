shader_type canvas_item;

uniform vec4 find_color: source_color;
uniform vec4 target_color: source_color;
uniform vec4 find_color2: source_color;
uniform vec4 target_color2: source_color;

void fragment() {
	vec4 pixel_color = texture(TEXTURE, UV);
	if (length(pixel_color - find_color) < 0.00001) {
		COLOR = target_color;
	}
	if (length(pixel_color - find_color2) < 0.00001) {
		COLOR = target_color2;
	}
}