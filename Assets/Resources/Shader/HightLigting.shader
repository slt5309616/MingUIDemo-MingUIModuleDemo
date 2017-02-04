Shader "Self-Illumin/HightLigting" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Lightness("Lightness", Float) = 1
		_Speed("Speed", Float) = 0
		_EmissionLM("EmissionLM（Lightingmap)", Float) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		float _Lightness, _Speed;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			float lightness = _Lightness;
			if(_Speed > 0.0001)
				lightness = _Lightness * abs(sin(_Time*_Speed)) + _Lightness * 0.12;

			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Emission = c.rgb * c.a * lightness;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
