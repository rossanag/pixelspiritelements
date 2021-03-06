#version 450

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
out vec4 fragColor;

float QTR_PI = 0.78539816339;
float HALF_PI = 1.5707963267948966192313216916398;
float PI = 3.1415926535897932384626433832795;
float TWO_PI = 6.2831853071795864769252867665590;
float TAU = 6.2831853071795864769252867665590;
float PHI = 1.618033988749894848204586834;
float EPSILON = 0.0000001;

float stroke(float x, float s, float w){
	float d = step(s, x + w * 0.5) - step(s, x - w * 0.5);
	return clamp(d, 0.0, 1.0);
}

float rectSDF(vec2 st, vec2 s){
	st = st * 2.0 - 1.0;
	return max(abs(st.x / s.x), abs(st.y / s.y));
}

vec2 rotate(vec2 st, float a){
	st = mat2(cos(a), -sin(a), sin(a), cos(a)) * (st - 0.5);
	return st+.5;
}

vec3 bridge(vec3 c,float d,float s,float w) {
  c *= 1.0 -stroke(d, s, w * 2.0);
  return c + stroke(d, s, w);
}

void main() {
  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  st.x *= u_resolution.x/u_resolution.y;
  st.y *= u_resolution.y/u_resolution.x;
  vec3 color = vec3(0.0);

	st.x = mix(1.0 - st.x, st.x, step(0.5, st.y));
	vec2 o = vec2(0.05, 0.0);
	vec2 s = vec2(1.0);
	float a = radians(45.0);
	float l = rectSDF(rotate(st + o, a), s);
	float r = rectSDF(rotate(st - o, -a), s);
	color += stroke(l, 0.145, 0.098);
	color = bridge(color, r, 0.145, 0.098);
  
  fragColor = vec4(color, 1.0);
}