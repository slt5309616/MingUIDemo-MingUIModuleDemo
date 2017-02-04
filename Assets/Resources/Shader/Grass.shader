// Upgrade NOTE: commented out 'float4 unity_LightmapST', a built-in variable
// Upgrade NOTE: commented out 'sampler2D unity_Lightmap', a built-in variable
// Upgrade NOTE: replaced tex2D unity_Lightmap with UNITY_SAMPLE_TEX2D

Shader "MC/Grass" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_MainColor("MainColor", Color) = (1.0, 1.0, 1.0, 1.0)
		_Cutout("Cutout", Range(0, 1)) = 0.2
		_Range("Range", Range(0, 0.2)) = 0.01
		_Speed("Speed", Range(0, 5)) = 1
		_Direction("Direction", Range(0, 360)) = 0
	}
	SubShader{
		Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }
		LOD 200
		Blend SrcAlpha OneMinusSrcAlpha
		Cull off
		Pass
		{
			Tags{"LightMode" = "VertexLMRGBM"}

			CGPROGRAM
			#include"UnityCG.cginc"
			#include"UnityShaderVariables.cginc"
			#include"Lighting.cginc"
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase

			// sampler2D unity_Lightmap;
			// float4 unity_LightmapST;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _MainColor;
			float _Cutout;
			float _Range;
			float _Speed;
			float _Direction;
			

			struct appdata_t
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};

			struct v2f {
				float4 position:SV_POSITION;
				float2 lmuv:TEXCOORD1;
				float2 mainuv:TEXCOORD0;
			};

			v2f vert(appdata_t v) {
				v2f o;
				o.mainuv = TRANSFORM_TEX(v.texcoord, _MainTex);
				float radian = radians(_Direction);
				v.vertex.x += o.mainuv.y > 0.1 ? sin(_Time.y * _Speed) * _Range * (cos(radian) - sin(radian)) : 0;
				v.vertex.z += o.mainuv.y > 0.1 ? sin(_Time.y * _Speed) * _Range * (sin(radian) + cos(radian)) : 0;
				o.position = mul(UNITY_MATRIX_MVP, v.vertex);
				o.lmuv = v.texcoord1 * unity_LightmapST.xy + unity_LightmapST.zw;
				return o;
			}

			half4 frag(v2f v):COLOR {
				float4 clr = tex2D(_MainTex, v.mainuv);
				clip(clr.a - _Cutout);
				half4 lm = UNITY_SAMPLE_TEX2D(unity_Lightmap, v.lmuv);
				clr.rgb += clr.rgb * DecodeLightmap(lm);
				return  clr * _MainColor;
			}
			ENDCG
		}

		Pass
		{
			Tags{ "LightMode" = "Vertex" }

			CGPROGRAM
			#include"UnityCG.cginc"
			#include"UnityShaderVariables.cginc"
			#include"Lighting.cginc"
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _MainColor;
			float _Cutout;
			float _Range;
			float _Speed;
			float _Direction;


			struct appdata_t
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f {
				float4 position:SV_POSITION;
				float2 mainuv:TEXCOORD1;
				float3 color:COLOR;
			};

			float3 VertexLights(float4 vertex)
			{
				float3 viewpos = mul(UNITY_MATRIX_MV, vertex).xyz;
				float3 lightColor = UNITY_LIGHTMODEL_AMBIENT.xyz;
				for (int i = 0; i < 4; i++) {
					float3 toLight = unity_LightPosition[i].xyz - viewpos.xyz * unity_LightPosition[i].w;
					float lengthSq = dot(toLight, toLight);
					float atten = 1.0 / (1.0 + lengthSq * unity_LightAtten[i].z);
					lightColor += unity_LightColor[i].rgb * atten;
				}
				return lightColor;
			}

			v2f vert(appdata_t v) {
				v2f o;
				o.mainuv = TRANSFORM_TEX(v.texcoord, _MainTex);
				float radian = radians(_Direction);
				v.vertex.x += o.mainuv.y > 0.1 ? sin(_Time.y * _Speed) * _Range * (cos(radian) - sin(radian)) : 0;
				v.vertex.z += o.mainuv.y > 0.1 ? sin(_Time.y * _Speed) * _Range * (sin(radian) + cos(radian)) : 0;
				o.position = mul(UNITY_MATRIX_MVP, v.vertex);
				o.color = VertexLights(v.vertex);
				return o;
			}

			half4 frag(v2f v) :COLOR{
				float4 clr = tex2D(_MainTex, v.mainuv);
				clip(clr.a - _Cutout);
				clr.rgb *= v.color;
				return  clr * _MainColor;
			}
			ENDCG
		}
	} 
	FallBack "Diffuse"
}
