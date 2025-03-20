shader_type canvas_item;

uniform float wind_speed;

uniform vec2 wind_dir;

void vertex(){
	VERTEX.x += wind_dir.x * (wind_speed / 15.0) * (UV.y - 1.0) + (sin(TIME) * (wind_speed / 90.0)) * (UV.y - 1.0);
}