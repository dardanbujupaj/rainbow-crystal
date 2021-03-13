shader_type canvas_item;
//render_mode blend_mix;

uniform bool red_enabled = true;
uniform bool green_enabled = true;
uniform bool blue_enabled = true;


void fragment() {
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV);
	
	if (!(red_enabled && green_enabled && blue_enabled)) {
		float avg = (COLOR.r + COLOR.g + COLOR.b) / 3.0;
		
		COLOR.r = red_enabled ? max(COLOR.r, avg) : avg;
		COLOR.g = green_enabled ? max(COLOR.g, avg) : avg;
		COLOR.b = blue_enabled ? max(COLOR.b, avg) : avg;
	}
	
}
