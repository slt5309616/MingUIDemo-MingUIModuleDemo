 Shader "Outlined/Diffuse" {
     Properties {
         _Color ("Main Color", Color) = (.5,.5,.5,1)
         _OutlineColor ("Outline Color", Color) = (0,0,0,1)
         _Outline ("Outline width", Range (-0.002, 0.03)) = .005
		 _BlendRatio ("Blend Ratio From Z", Range (0, 1)) = .5
         _MainTex ("Base (RGB)", 2D) = "white" { }
     }
     
 CGINCLUDE
 #include "UnityCG.cginc"
 
 struct appdata {
     float4 vertex : POSITION;
     float3 normal : NORMAL;
 };
 
 struct v2f {
     float4 pos : POSITION;
     float4 color : COLOR;
 };
 
 uniform float _Outline;
 uniform float4 _OutlineColor;
 uniform float _BlendRatio;
 v2f vert(appdata v) {
     v2f o;
     o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
	 float3 dir = normalize(v.normal);
     float3 norm   = mul ((float3x3)UNITY_MATRIX_IT_MV, dir);
     float2 offset = TransformViewToProjection(norm.xy);
 
     o.pos.xy += offset * o.pos.z * _Outline;
     o.color = _OutlineColor;
	 o.color.a = o.color.a * ((norm.z*norm.z + 0.01) * _BlendRatio);
     return o;
 }
 ENDCG
 
     SubShader {
         //Tags {"Queue" = "Overlay" }
		 CGPROGRAM
		 #pragma surface surf Lambert
 
		 sampler2D _MainTex;
		 fixed4 _Color;
 
		 struct Input {
			 float2 uv_MainTex;
		 };
 
		 void surf (Input IN, inout SurfaceOutput o) {
			 fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			 o.Albedo = c.rgb*0.85 + _OutlineColor*0.15;
			 o.Alpha = c.a;
		 }
		 ENDCG
 
         Pass {
             Name "OUTLINE"
             Tags { "LightMode" = "Always" "Queue" = "Overlay" }
             Cull Front
             ZWrite On
             ZTest LEqual
             ColorMask RGB
             Blend SrcAlpha OneMinusSrcAlpha
             Offset 15,15
 
             CGPROGRAM
             #pragma vertex vert
             #pragma fragment frag
             half4 frag(v2f i) :COLOR { 
			 if(_Outline<0)
				return (0,0,0,0);
			 else
				return i.color; 
			 }
             ENDCG
         }
     }
     
     Fallback "Diffuse"
 }