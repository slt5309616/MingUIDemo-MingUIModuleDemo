﻿Shader "Hidden/Custom/AlphaMask 1"
{
   Properties
   {
      _MainTex ("Base (RGB)", 2D) = "white" {}
      _Mask ("Culling Mask", 2D) = "white" {}
      _Cutoff ("Alpha cutoff", Range (0,1)) = 0.1
	  _Color ("Color", Color) = (1,1,1,1)
   }
   SubShader
   {
      Tags {"Queue"="Transparent"}
      Lighting Off
      ZWrite Off
      Blend SrcAlpha OneMinusSrcAlpha
      AlphaTest GEqual [_Cutoff]
      Pass
      {
         

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _Mask;
			float4 _ClipRange0 = float4(0.0, 0.0, 1.0, 1.0);
			float2 _ClipArgs0 = float2(1000.0, 1000.0);
			fixed4 _Color;

			struct appdata_t
			{
				float4 vertex : POSITION;
				half4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : POSITION;
				half4 color : COLOR;
				float2 texcoord : TEXCOORD0;
				float2 worldPos : TEXCOORD1;
			};

			v2f vert (appdata_t v)
			{
				v2f o = (v2f)0;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.color = v.color;
				o.texcoord = v.texcoord;
				o.worldPos = v.vertex.xy * _ClipRange0.zw + _ClipRange0.xy;
				return o;
			}

			half4 frag (v2f IN) : COLOR
			{
				// Softness factor
				float2 factor = (float2(1.0, 1.0) - abs(IN.worldPos)) * _ClipArgs0;
			
				// Sample the texture
				half4 col;
				half4 colMask = tex2D(_Mask, IN.texcoord);
				if (_Color.r < 0.001)  
				{
					
					col = tex2D(_MainTex, IN.texcoord);  
					half grey = dot(col.rgb, half3(0.299, 0.587, 0.114));  
					col.rgba = half4(grey, grey, grey,colMask.a); 
				}
				else  
				{  
					col = tex2D(_MainTex, IN.texcoord) * IN.color;  
				}
				col.a *= clamp( min(factor.x, factor.y), 0.0, colMask.a);
				return col;
			}
			ENDCG
		}
   }
}