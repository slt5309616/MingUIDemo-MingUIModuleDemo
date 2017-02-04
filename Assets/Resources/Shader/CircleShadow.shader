Shader "Custom/CircleShadow" {
Properties {
	_Color ("Main Color", Color) = (0.1,0.1,0.1,1)  //范围（0,1），0表示全黑，1表示全白
	_Center("Center",Vector)=(0,0,0)
	_Radius ("Radius", Float) = 0.5
	_Cutoff ("Alpha cutoff", Range(0,1)) = 0.005
}
SubShader {
	Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="Transparent"}
	//LOD 200
	Blend SrcAlpha OneMinusSrcAlpha 
	Lighting Off
	//Cull Off
	//AlphaTest Greater [_Cutoff]
CGPROGRAM
//#pragma surface surf Lambert alphatest:_Cutoff
#pragma surface surf  Lambert vertex:vert1   // alphatest:_Cutoff 

fixed4 _Color;
float _Amount;
float3 _Center;
float _Radius;
struct Input {
	float2 uv_MainTex;
	float3 worldPos;
	float3 my_vertPos;
};


      void vert1 (inout appdata_full v,out Input IN) {
			IN.my_vertPos =  v.vertex;
      }

		void surf (Input IN, inout SurfaceOutput o) {
			o.Albedo = _Color;
			o.Emission = _Color.rgb;
			float d = distance(_Center.xz, IN.my_vertPos.xz);
			if(d>_Radius){
				o.Alpha =0;
			}else{
				o.Alpha =(_Radius-d)*0.25/0.05;//中间最高透明度0.8，边缘有0.1米渐变透明
			}
		}
ENDCG

} 
FallBack "Self-Illumin/VertexLit"
}