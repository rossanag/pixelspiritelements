#version 450

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
out vec4 fragColor;

float PI = 3.1415926535897932384626433832795;
float TAU = 6.2831853071795864769252867665590;

float stroke(float x, float s, float w){
	float d = step(s, x + w * 0.5) - step(s, x - w * 0.5);
	return clamp(d, 0.0, 1.0);
}

float fill(float x, float size){
	return 1.0 - step(size, x);
}

float polySDF(vec2 st, int V){
	st = st * 2.0 - 1.0;
	float a = atan(st.x, st.y) + PI;
	float r = length(st);
	float v = TAU / float(V);
	return cos(floor(0.5 + a / v) * v - a) * r;
}

float heartSDF(vec2 st) {
	st -= vec2(0.5, 0.8);
	float r = length(st) * 5.0;
	st = normalize(st);
	return r - ((st.y * pow(abs(st.x), 0.67)) / (st.y + 1.5) - (2.0) * st.y + 1.26);
}

void main() {
  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  st.x *= u_resolution.x/u_resolution.y;
  st.y *= u_resolution.y/u_resolution.x;
  vec3 color = vec3(0.0);

	color += fill(heartSDF(st), 0.5);
	color -= stroke(polySDF(st, 3), 0.15, 0.05);
  
  fragColor = vec4(color, 1.0);
}