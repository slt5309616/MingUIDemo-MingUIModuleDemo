Shader "MC/MCGlass" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Cube("环境贴图", Cube) = "_Skybox" {}
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_ReflectionTint("反射系数", Range(0, 1)) = 0.5
		_RefractionTint("折射系数", Range(0, 1)) = 0.5
		_Power("菲涅尔", Range(1,10)) = 5
	}
	SubShader {
		Tags { "Queue" = "Transparent-10" }
		LOD 200
		GrabPass
		{
			Name "BASE"
			Tags{ "LightMode" = "Always" }
		}

		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 4.0

		sampler2D _MainTex;
		samplerCUBE _Cube;
		sampler2D _GrabTexture : register(s0);

		uniform half4 _GrabTexture_TexelSize;

		struct Input {
			float2 uv_MainTex;
			float4 position;
			float3 normal;
			float3 worldPos  : TEXCOORD2;
			float4 proj0   	 : TEXCOORD3;
			float4 proj1	 : TEXCOORD4;
		};

		half _ReflectionTint;
		half _Glossiness;
		half _RefractionTint;
		half _Alpha;
		half _Metallic;
		half _Power;
		fixed4 _Color;

		void vert(inout appdata_full v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input, o);
			o.worldPos = v.vertex.xyz;
			o.position = mul(UNITY_MATRIX_MVP, v.vertex);
			o.normal = v.normal;
			o.proj0 = ComputeScreenPos(o.position);
			COMPUTE_EYEDEPTH(o.proj0.z);

			o.proj1 = o.proj0;
			#if UNITY_UV_STARTS_AT_TOP
				o.proj1.y = (o.position.w - o.position.y) * 0.5;
			#endif
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;

			float3 worldView = (IN.worldPos - _WorldSpaceCameraPos);
			half fresnel = sqrt(1.0 - dot(-normalize(worldView), IN.normal));


			IN.proj0.xy += o.Normal.xy * 0.5;

			half3 reflection = texCUBE(_Cube, reflect(worldView, IN.normal)).rgb * _ReflectionTint;

			IN.proj1.xy += o.Normal.xy * _GrabTexture_TexelSize.xy * (20.0 * IN.proj1.z * _RefractionTint);
			half3 refraction = tex2Dproj(_GrabTexture, IN.proj1).rgb;
			refraction = lerp(refraction, refraction * _Color.rgb, 0.5);

			fresnel = pow(fresnel, _Power);
			fresnel = (0.8 * fresnel + 0.2) * _RefractionTint;
			o.Albedo = lerp(refraction, reflection, fresnel)*0.9f + c.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
