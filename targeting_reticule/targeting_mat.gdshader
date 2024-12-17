// NOTE: Shader automatically converted from Godot Engine 4.4.dev's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx, shadows_disabled;


instance uniform vec4 albedo : source_color;
instance uniform float grow : hint_range(-16.0, 16.0, 0.001);
uniform float point_size : hint_range(0.1, 128.0, 0.1);

uniform float roughness : hint_range(0.0, 1.0);

uniform float specular : hint_range(0.0, 1.0, 0.01);
uniform float metallic : hint_range(0.0, 1.0, 0.01);

uniform vec4 emission : source_color;
uniform float emission_energy : hint_range(0.0, 100.0, 0.01);

uniform float subsurface_scattering_strength : hint_range(0.0, 1.0, 0.01);
uniform sampler2D texture_subsurface_scattering : hint_default_white, filter_linear_mipmap, repeat_enable;



void vertex() {
	// Grow: Enabled
	VERTEX += NORMAL * grow;
}

void fragment() {
	vec2 base_uv = UV;

	ALBEDO = albedo.rgb;

	METALLIC = metallic;
	SPECULAR = specular;

	vec4 roughness_texture_channel = vec4(1.0, 0.0, 0.0, 0.0);
	ROUGHNESS = roughness;


	// Emission Operator: Multiply
	EMISSION = emission.rgb * emission_energy;
	ALPHA *= albedo.a;

	// Subsurface Scattering: Enabled
	SSS_STRENGTH = subsurface_scattering_strength;
}
