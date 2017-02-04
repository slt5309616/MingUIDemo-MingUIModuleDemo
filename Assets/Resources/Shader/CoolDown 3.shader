Shader "MC/CoolDown 3" {
	Properties 
	{
		_MainTex("Base (RGB), Alpha (A)", 2D) = "black" {}
		_Percent("Percent", Range(0.0, 1.0)) =1.0
	}

	SubShader
	{
		LOD 100

		Tags
		{	
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}	

		Cull Off
		Lighting Off
		ZWrite Off
		Fog{ Mode Off }
		Offset -1, -1
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata_t
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Percent;

			v2f vert(appdata_t v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.texcoord = v.texcoord;
				o.color = v.color;
				return o;
			}

			fixed4 frag(v2f i) : COLOR
			{
				fixed4 col;
				if (i.texcoord.y > _Percent)
				{
					col = tex2D(_MainTex, i.texcoord);
					float grey = dot(col.rgb, float3(0.299, 0.587, 0.114));
					col.rgb = float3(grey, grey, grey);
				}
				else
				{
					col = tex2D(_MainTex, i.texcoord) * i.color;
				}
				return col;
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
