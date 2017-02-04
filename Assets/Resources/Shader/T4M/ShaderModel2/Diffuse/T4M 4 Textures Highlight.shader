Shader "T4MShaders/ShaderModel2/Diffuse/T4M 4 Textures Highlight" {
Properties {
	_Splat0 ("Layer 1", 2D) = "white" {}
	_Splat1 ("Layer 2", 2D) = "white" {}
	_Splat2 ("Layer 3", 2D) = "white" {}
	_Splat3 ("Layer 4", 2D) = "white" {}
	_Control ("Control (RGBA)", 2D) = "white" {}
	_MainTex ("Never Used", 2D) = "white" {}
	_Lightness("Lightness", Range(0, 20)) = 2
	_Glow("Glow", Range(0, 1)) = 0.1
	_Speed("Speed", Float) = 0
}
                
SubShader {
	Tags {
   "SplatCount" = "4"
   "RenderType" = "Opaque"
	}
CGPROGRAM
#pragma surface surf Lambert 
#pragma exclude_renderers xbox360 ps3
#pragma target 4.0

struct Input {
	float2 uv_Control : TEXCOORD0;
	float2 uv_Splat0 : TEXCOORD1;
	float2 uv_Splat1 : TEXCOORD2;
	float2 uv_Splat2 : TEXCOORD3;
	float2 uv_Splat3 : TEXCOORD4;
};
 
sampler2D _Control;
sampler2D _Splat0,_Splat1,_Splat2,_Splat3;
float _Lightness, _Glow, _Speed;
 

void surf (Input IN, inout SurfaceOutput o) {
	float lightness = _Lightness;
	if(_Speed > 0.0001)
		lightness = _Lightness * abs(sin(_Time*_Speed)) + _Lightness * 0.12;

	fixed4 splat_control = tex2D (_Control, IN.uv_Control).rgba;
	fixed3 lay1 = tex2D (_Splat0, IN.uv_Splat0);
	fixed4 lay2 = tex2D (_Splat1, IN.uv_Splat1);
	fixed3 lay3 = tex2D (_Splat2, IN.uv_Splat2);
	fixed3 lay4 = tex2D (_Splat3, IN.uv_Splat3);
	o.Albedo.rgb = (lay1 * splat_control.r + lay2 * splat_control.g * (1 + lightness*_Glow)+ lay3 * splat_control.b + lay4 * splat_control.a);
	o.Emission.rgb = lay2 * splat_control.g * lay2.a * lightness + + lay2 * splat_control.g * lightness*_Glow*0.5;
	o.Alpha = 0.0;
}
ENDCG 
}
// Fallback to Diffuse
Fallback "Diffuse"
}
