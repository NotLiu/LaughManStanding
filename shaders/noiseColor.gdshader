shader_type canvas_item;

uniform sampler2D noise : repeat_enable;
uniform sampler2D gradientColor;
uniform float scaleAmplitude = 1.0;
uniform float timeScale = 1.0;

uniform float export = 0.0;

vec2 random(vec2 uv){
    uv = vec2( dot(uv, vec2(127.1,311.7) ),
               dot(uv, vec2(269.5,183.3) ) );
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}

float noiseFloat(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix( mix( dot( random(uv_index + vec2(0.0,0.0) ), uv_fract - vec2(0.0,0.0) ),
                     dot( random(uv_index + vec2(1.0,0.0) ), uv_fract - vec2(1.0,0.0) ), blur.x),
                mix( dot( random(uv_index + vec2(0.0,1.0) ), uv_fract - vec2(0.0,1.0) ),
                     dot( random(uv_index + vec2(1.0,1.0) ), uv_fract - vec2(1.0,1.0) ), blur.x), blur.y) + 0.5;
}

void vertex() {
	//VERTEX.x *= 1.0 + sin(TIME * timeScale) * scaleAmplitude / 2.0;
	//VERTEX.y *= 1.0 + sin(TIME * timeScale) * scaleAmplitude / 2.0;
}

vec3 get_gradient_color(float position){
	return texture(gradientColor, vec2(position, 1.0)).rgb;
}

void fragment() {
	vec4 noiseTexture = texture(noise, vec2(UV.x * noiseFloat(UV) + sin(mod(TIME * timeScale, 100.0)) * scaleAmplitude, UV.y * noiseFloat(UV) + cos(mod(TIME * timeScale, 100.0)) * scaleAmplitude));
		
	if(noiseTexture.x < 0.4){
		COLOR.rgb *=  get_gradient_color(mod(mod(TIME * timeScale, 1.1) * 1.25, 0.75));
	}
	else if(noiseTexture.x < 0.6){
		COLOR.rgb *=  get_gradient_color(mod(mod(TIME * timeScale, 1.1) * 1.5, 1.0));
	}
	else{
		COLOR.rgb *=  get_gradient_color(mod(mod(TIME * timeScale, 1.1) * 1.75, 1.25));
	}
	
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
