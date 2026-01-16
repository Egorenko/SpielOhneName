shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

float random (float x) {
    return fract(sin(dot(vec2(TIME, x),
        vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
	COLOR = vec4(random(10.0)*100.0, random(100.0)*100.0, random(50.0)*100.0, COLOR.a);
	
	//if (COLOR != vec4(0.0, 0.0, 0.0, COLOR.a)){
	//	if (random(vec2(TIME, 0.0)) <= 0.1){
	//		COLOR = vec4(0.0, 0.0, 0.0, COLOR.a);
	//	}
	//}
	
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
