// https://godotshaders.com/shader/3d-health-bar/
shader_type spatial;
render_mode unshaded;

uniform bool use_billboard;
uniform vec4 primary_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 ghost_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 background_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
instance uniform float primary_health : hint_range(0.0, 1.0) = 0.75;
instance uniform float ghost_health : hint_range(0.0, 1.0) = 0.5;

void vertex() {
	if (use_billboard){
        MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
	}
}

void fragment() {
	if(UV.x < primary_health) 
		{ALBEDO = primary_color.rgb;}
	else if (UV.x < ghost_health)
		{ALBEDO = ghost_color.rgb;}
	else {ALBEDO = background_color.rgb;}
	//ALBEDO = UV.x < primary_health ? primary_color.rgb : background_color.rgb;
	ALPHA = UV.x < primary_health ? primary_color.a : background_color.a;
}
