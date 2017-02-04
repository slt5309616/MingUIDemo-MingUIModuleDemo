Shader "Self-Illumin/Unit_Diffuse" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
	_Cutoff ("Cutoff Value", Range(0,1)) = 0.5
	_lightColor ("LightColor", Color) = (0.47,0.47,0.47,1)
	_addColor ("AddColor", Color) = (0.47,0.47,0.47,1)
	_ChangeMode("ChangeMode", Float) = 0
}
SubShader {
	Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
	LOD 200
CGPROGRAM
//#pragma surface surf Lambert alphatest:_Cutoff
     #pragma surface surf SimpleSpecular  alphatest:_Cutoff
sampler2D _MainTex;
fixed4 _lightColor;
fixed4 _addColor;
 float _ChangeMode; 

fixed4 _Color;
struct Input {
	float2 uv_MainTex;

};

	  half4 LightingSimpleSpecular (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) 
		{
		if(_ChangeMode==1){
			half3 h = normalize (lightDir + viewDir);

			half diff = max (0, dot (s.Normal, viewDir));

			half4 c;

			c.rgb =(s.Albedo * _lightColor.rgb * diff ) * (atten * 2);
			c.a = s.Alpha;
			return c;
		}else{
		   fixed diff = max (0, dot (s.Normal, lightDir));
	
	       fixed4 c;
	       c.rgb = s.Albedo * _LightColor0.rgb * (diff * atten );
	       c.a = s.Alpha;
	       return c;
		}


		}

void surf (Input IN, inout SurfaceOutput o) {
	  fixed4 tex  =tex2D (_MainTex, IN.uv_MainTex);
if(_ChangeMode==1){
		  o.Albedo = tex.rgb;
		  o.Emission = _addColor.rgb;
		  o.Alpha = tex.a;
		  o.Gloss =100;
}else{
	fixed4 c = tex * _Color;
	o.Albedo = c.rgb;
	o.Emission = c.rgb;
	o.Alpha = c.a;
}
}
ENDCG
} 
FallBack "Self-Illumin/VertexLit"
}
