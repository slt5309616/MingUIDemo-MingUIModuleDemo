﻿Shader "MyEffect/SceneFade" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_FadeRatio("_FadeRatio",Float) = 0.0  
	}
	SubShader {  
        Pass {  
            CGPROGRAM  
  
            #pragma vertex vert  
            #pragma fragment frag  
  
            uniform sampler2D _MainTex;  
            uniform float _FadeRatio;   
              
            struct Input {  
                float4 pos : POSITION;  
                float2 uv : TEXCOORD0;  
            };  
  
            struct v2f {  
                float4 pos : POSITION;  
                float2 uv : TEXCOORD0;  
            };  
  
            v2f vert( Input i) {  
                v2f o;  
                o.pos = mul (UNITY_MATRIX_MVP, i.pos);  
                o.uv = i.uv;  
                return o;  
            }  
  
            float4 frag (v2f i) : COLOR {              
                float4 outColor;                  
                outColor = tex2D( _MainTex, i.uv) - _FadeRatio;  
                return outColor;  
            }  
            ENDCG  
        }  
    }  
    Fallback off  
}
