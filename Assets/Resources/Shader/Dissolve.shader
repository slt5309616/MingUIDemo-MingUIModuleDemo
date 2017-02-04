 Shader "MC/Dissolve" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_NoiseTex ("波动噪声贴图(取r值)", 2D) = "white" {}
		_NoiseRange("波动幅度", Range(1, 10)) = 5
		_DefaultRadius("半径", Range(0, 20)) = 10
		_EdgeColor("边缘颜色", Color) = (1.0, 1.0, 1.0,0)
		_EdgeWidth("边缘宽度", Range(0, 1)) = 0.2
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Lambert vertex:vert
		#pragma target 3.0


		sampler2D _MainTex;
		sampler2D _NoiseTex;
		float4 _EdgeColor;
		float4 _Origin;
		float _NoiseRange;
		float _Radius;
		float _DefaultRadius;
		float _EdgeWidth;
		int _IsShow = 1;//1开启 0关闭

		struct Input {
			float2 uv_MainTex;
			float4 position;
		};

		void vert(inout appdata_full v, out Input o) {
			o.position = mul(_Object2World, v.vertex);
			o.uv_MainTex = v.texcoord.xy;//必须赋值
		}

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			//_IsShow = 1;
			//_Origin = float4(65, 31, 215, 0);
			//_Radius = _DefaultRadius;
			if (_IsShow == 1) {
				float4 noise = tex2D(_NoiseTex, IN.uv_MainTex + _Time.x * 2);
				float r = distance(IN.position.xz, _Origin.xz) + noise.x * _NoiseRange;
				if (r < _Radius) {
					clip(-1);
				}
				else if (r < _Radius + _EdgeWidth) {//描边
					c.rgb = _EdgeColor.rgb;
				}
			}
			
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
