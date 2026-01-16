shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

instance uniform vec3 colors = vec3(229.0, 166.0, 39.0);

void fragment() {
	// Called for every pixel the material is visible on.
	float greyscale_color = COLOR.r * 0.299 + COLOR.g * 0.587 + COLOR.b * 0.114;
	// also change black
	if(greyscale_color <= 0.0){
		greyscale_color = 1.0;
	}
	
	vec3 ColorValue = colors/255.0;
	COLOR = vec4(
	greyscale_color * ColorValue.r,
	greyscale_color * ColorValue.g,
	greyscale_color * ColorValue.b,
	COLOR.a);

}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
