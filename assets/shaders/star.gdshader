shader_type canvas_item;

float rand(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
	float size = 100.0;
	float prob = 0.9;
	vec2 pos = floor(1.0 / size * FRAGCOORD.xy);
	float alpha = 0.0;
	float starValue = rand(pos);

	if (starValue > prob) {
		vec2 center = size * pos + vec2(size, size) * 0.5;
		float t = 0.9 + 0.2 * sin(TIME * 2.0 + (starValue - prob) / (1.0 - prob) * 45.0);
		alpha = 1.0 - distance(FRAGCOORD.xy, center) / (0.5 * size);
		alpha *= t / (abs(FRAGCOORD.y - center.y)) * t / (abs(FRAGCOORD.x - center.x));
	} else if (rand(SCREEN_UV.xy / 20.0) > 0.996) {
		float r = rand(SCREEN_UV.xy);
		alpha = r * (0.85 * sin(TIME * (r * 1.5) + 720.0 * r) + 0.95);
	}
	
	COLOR.a = alpha;
}