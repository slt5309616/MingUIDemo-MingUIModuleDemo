Shader "MC/BlindStuff" {
	Properties {
		_MainColor("MainColor", Color) = (1.0, 1.0, 1.0)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Alpha("Alpha", Range(0, 1)) = 0.5
		//_UseAlpha("UseAlpha", Float) = 1.0
		_Cutout("Cutout", Range(0, 1)) = 0.1
	}
	SubShader {
		Tags {"RenderType" = "Transparent" "Queue" = "Transparent" }
		LOD 200
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaTest Greater [_Cutout]
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		float _Alpha;
		float3 _MainColor;
		float _Cutout;
		float _UseAlpha;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb * _MainColor;
			//_Alpha = _UseAlpha > 0 ? _Alpha : 1;
			o.Alpha = c.a * _Alpha;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
