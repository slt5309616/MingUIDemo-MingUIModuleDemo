Shader "PureColor" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_offsetWorld ("offsetWorld",Vector) = (0,0,0)
	_offsetLocal ("offsetLocal",Vector) = (0,0,0)
	_Cutoff ("Alpha cutoff", Range (0,1)) = 0.1
}
	SubShader {
	Tags { "Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="Transparent" }
      Blend SrcAlpha OneMinusSrcAlpha 
	  Lighting Off 
	  Cull Off
      CGPROGRAM
      #pragma surface surf Lambert vertex:vert alphatest:_Cutoff 

      float4 _Color;
      float3 _offsetWorld;
	  float3 _offsetLocal;

      struct Input {
          float2 uv_MainTex;
      };
      void vert (inout appdata_full v) {
          v.vertex.xyz +=mul(_World2Object,_offsetWorld);
		   v.vertex.xyz +=_offsetLocal;
      }

      sampler2D _MainTex;
      void surf (Input IN, inout SurfaceOutput o) {
          //o.Albedo = _Color;
		  o.Emission = _Color;
		  o.Alpha = _Color.a;
      }
      ENDCG
    } 
    Fallback "Diffuse"
  }
