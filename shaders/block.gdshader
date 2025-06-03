shader_type canvas_item;

uniform vec4 src_c1: source_color;
uniform vec4 src_c2: source_color;
uniform vec4 src_c3: source_color;
uniform vec4 out_c1: source_color;
uniform vec4 out_c2: source_color;
uniform vec4 out_c3: source_color;

void fragment() {
	vec4 pixel_color = texture(TEXTURE, UV);
	if (length(pixel_color - src_c1) < 0.1) {
		COLOR = out_c1;
	}
	if (length(pixel_color - src_c2) < 0.1) {
		COLOR = out_c2;
	}
	if (length(pixel_color - src_c3) < 0.1) {
		COLOR = out_c3;
	}
}
