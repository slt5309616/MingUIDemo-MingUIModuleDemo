Shader "Projector/Light" { 
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_ShadowTex ("Cookie", 2D) = "" {}
		_FalloffTex ("FallOff", 2D) = "" {}
		_MoveVector("x,y:Direction,z:speed",Vector) = (1,1,10,0)
	}
	 
	Subshader {
		Tags {"Queue"="Transparent"}
		Pass {
			ZWrite Off
			Fog { Color (0, 0, 0) }
			ColorMask RGB
			Blend DstColor One
			Offset -1, -1
	 
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			struct v2f {
				float4 uvShadow : TEXCOORD0;
				float4 uvFalloff : TEXCOORD1;
				float4 pos : SV_POSITION;
			};

			struct appdata_t
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			float4 _MoveVector;
			float4 _ShadowTex_ST;
			float4x4 _Projector;
			float4x4 _ProjectorClip;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
				//float2 mainuv = TRANSFORM_TEX(v.texcoord, _ShadowTex);

				float4 realV = v.vertex*float4(_ShadowTex_ST.x,_ShadowTex_ST.y,1,1) + float4(0,0,_ShadowTex_ST.z,_ShadowTex_ST.w) + float4(_MoveVector.x*_Time.x * _MoveVector.z,0,_MoveVector.y * _Time.x * _MoveVector.z,0);
				
				o.uvShadow = mul (_Projector, realV) ;
				o.uvFalloff = mul (_ProjectorClip, v.vertex);
				return o;
			}
			
			fixed4 _Color;
			sampler2D _ShadowTex;
			sampler2D _FalloffTex;
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 texS = tex2Dproj (_ShadowTex, UNITY_PROJ_COORD(i.uvShadow));
				texS.rgb *= _Color.rgb;
				texS.a = 1.0-texS.a;
	 
				fixed4 texF = tex2Dproj (_FalloffTex, UNITY_PROJ_COORD(i.uvFalloff));
				fixed4 res = texS * texF.a;
				return res;
			}
			ENDCG
		}
	}
}
