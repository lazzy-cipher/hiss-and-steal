shader_type canvas_item;

uniform int rotation: hint_enum("0°:0", "90° clockwise:90", "90° counter-clockwise:270", "180°:180") = 0;

void fragment() {
	vec2 local_uv = (UV - REGION_RECT.xy) / REGION_RECT.zw;

	switch(rotation) {
	case 90:
		local_uv = vec2(local_uv.y, 1.0 - local_uv.x);
		break;
	case 180:
		local_uv = vec2(1.0 - local_uv.x, 1.0 - local_uv.y);
		break;
	case 270:
		local_uv = vec2(1.0 - local_uv.y, local_uv.x);
		break;
	case 0:
	default:
		break;
	}

	vec2 atlas_uv = REGION_RECT.xy + local_uv * REGION_RECT.zw;
	COLOR = texture(TEXTURE, atlas_uv);
}
