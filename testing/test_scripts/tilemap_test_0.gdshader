shader_type canvas_item;
// https://www.youtube.com/watch?v=eYlBociPwdw
uniform sampler2D overlay_tex_grass: repeat_enable, filter_nearest;
uniform vec4 mask_grass : source_color ;
uniform sampler2D overlay_tex_dirt: repeat_enable, filter_nearest;
uniform vec4 mask_dirt : source_color ;
uniform sampler2D overlay_tex_water: repeat_enable, filter_nearest;
uniform vec4 mask_water : source_color ;
uniform float scale_tex = 0.01;
varying vec2 world_position;

void vertex() {
	// Called for every vertex the material is visible on.
	world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0,1.0)).xy;
}

void fragment() {
	// Called for every pixel the material is visible on.
	if(COLOR == mask_grass) {
		COLOR = texture(overlay_tex_grass, world_position * scale_tex);
	} else if(COLOR == mask_dirt) {
		COLOR = texture(overlay_tex_dirt, world_position * scale_tex);		
	} else if(COLOR == mask_water) {
		COLOR = texture(overlay_tex_water, world_position * scale_tex);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
