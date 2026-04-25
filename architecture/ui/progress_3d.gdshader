// https://godotshaders.com/shader/3d-health-bar/
shader_type spatial;
render_mode unshaded;

uniform bool use_billboard;
instance uniform vec4 primary_color : source_color = vec4(.1, 1.0, .1, 1.0);
uniform vec4 ghost_color : source_color = vec4(1.0, .1, .1, 1.0);
uniform vec4 background_color : source_color = vec4(0.0, 0.0, 0.0, .5);
uniform vec4 segment_color : source_color = vec4(.0, .0, .0, 1.0);
instance uniform int segments = 1;
instance uniform float primary_ratio : hint_range(0.0, 1.0) = 0.75;
instance uniform float ghost_ratio : hint_range(0.0, 1.0) = 0.5;

bool is_near(float value, float target) {
	return (value + .01) >= target && (value -.01) <= target;
}

void vertex() {
	if (use_billboard){
        MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
	}
}

void fragment() {
	
	if(UV.x < primary_ratio) 
		{ALBEDO = primary_color.rgb;}
	else if (UV.x < ghost_ratio)
		{ALBEDO = ghost_color.rgb;}
	else {ALBEDO = background_color.rgb;}
	//ALBEDO = UV.x < primary_health ? primary_color.rgb : background_color.rgb;
	ALPHA = UV.x < primary_ratio ? primary_color.a : background_color.a;
	
	// If near the boarder of a segment, make a segment line
	if (segments > 1) {
		
		for (int i = 0; i < segments+1; i ++) // https://www.reddit.com/r/godot/comments/w0qpwh/is_it_possible_to_use_for_loop_in_shader/
		if (is_near(UV.x,  1.0/float(segments) * float(i))) {
			ALBEDO = segment_color.rgb;
			}
	}
}


