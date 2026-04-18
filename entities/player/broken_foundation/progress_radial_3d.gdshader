// modded from https://godotshaders.com/shader/health-circle/
shader_type spatial;
render_mode unshaded;

const float width = 1.0;
//uniform float gradient_ease = .50;
instance uniform float fill_ratio = 0.8;
uniform sampler2D albedo: source_color;

void fragment() {
	float fill_angle = fill_ratio * 3.141592656 * 2.0;
	vec2 uv = UV * 2.0 - 1.0;
	if (atan(uv.x, uv.y) + 3.141592656 < fill_angle) {
		float inner_width = 1.0 - width;
		inner_width *= inner_width;
		float d = uv.x * uv.x + uv.y * uv.y;
		if (d >= inner_width && d <= 1.0) {
			//float w = abs((1.0 + inner_width) / 2.0 - d) / (1.0 - inner_width);
			//w = 1.0 - pow(w + 0.5, gradient_ease);
			ALBEDO = COLOR.rgb; ////vec3( textureGrad(albedo, UV, 1.0, 1.0) // dFdx(uv), dFdy(uv) ).g); // vec3(1.0);
			ALBEDO = texture(albedo, UV).rgb;
			ALPHA = 1.0;
		} else {
			ALPHA = 0.0;
		}
	} else {
		ALPHA = 0.0;
	}
}