#version 450

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
out vec4 fragColor;

float TAU = 6.2831853071795864769252867665590;

float stroke(float x, float s, float w){
	float d = step(s, x + w * 0.5) - step(s, x - w * 0.5);
	return clamp(d, 0.0, 1.0);
}

float circleSDF(vec2 st){
	return length(st - 0.5) * 2.0;
}

float fill(float x, float size){
	return 1.0 - step(size, x);
}

vec2 rotate(vec2 st, float a){
	st = mat2(cos(a),-sin(a), sin(a),cos(a))*(st-.5);
	return st+.5;
}

float starSDF(vec2 st, int V, float s) {
	st = st * 4.0 - 2.0;
	float a = atan(st.y, st.x) / TAU;
	float seg = a * float(V);
	a = ((floor(seg) + 0.5) / float(V) + mix(s, -s, step(0.5, fract(seg)))) * TAU;
	return abs(dot(vec2(cos(a),sin(a)), st));
}

float flowerSDF(vec2 st, int N) {
	st = st * 2.0 - 1.0;
	float r = length(st) * 2.0;
	float a = atan(st.y, st.x);
	float v = float(N) * 0.5;
	return 1.0 - (abs(cos(a * v)) * 0.5 + 0.5) / r;
}

void main() {
  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  st.x *= u_resolution.x/u_resolution.y;
  st.y *= u_resolution.y/u_resolution.x;
  vec3 color = vec3(0.0);

	color += fill(flowerSDF(st, 5), 0.25);
	color -= step(0.95, starSDF(rotate(st, 0.628), 5, 0.1));
	color = clamp(color, 0.0, 1.0);
	float circle = circleSDF(st);
	color -= stroke(circle, 0.1, 0.05);
	color += stroke(circle, 0.8, 0.07);
  
  fragColor = vec4(color, 1.0);
}