Shader "Dissolve/Dissolve_MC" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
	_Shininess ("Shininess", Range (0.03, 1)) = 0.078125
	_Amount ("Amount", Range (0, 1)) = 0.5
	_Dir("Dir", int) = 1
	_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
	_MainTex2 ("Base (RGB) Gloss (A)", 2D) = "white" {}
}
SubShader { 
	Tags { "RenderType"="Opaque" }
	LOD 400
	cull off
	
	
CGPROGRAM
// Upgrade NOTE: excluded shader from OpenGL ES 2.0 because it does not contain a surface program or both vertex and fragment programs.

#pragma target 3.0
#pragma surface surf BlinnPhong addshadow



sampler2D _MainTex;
sampler2D _MainTex2;

fixed4 _Color;
half _Shininess;
half _Amount;
static half3 Color = float3(1,1,1);
half _Dir;



struct Input {
	float2 uv_MainTex;
	float2 uv_MainTex2;
	float2 uv_BumpMap;
	float3 worldPos;
	float4 screenPos;
};

void vert (inout appdata_full v, out Input o) {}


void surf (Input IN, inout SurfaceOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	o.Albedo = tex.rgb * _Color.rgb;
	float3 screenPosNormal = IN.screenPos.xyz / IN.screenPos.w;
	float ClipTex;
	if(_Dir == 1){
		ClipTex = 1 - screenPosNormal.y; 
	}else if(_Dir == 2){
		ClipTex = screenPosNormal.y; 
	}else if(_Dir == 3){
		ClipTex = screenPosNormal.x; 
	}else if(_Dir == 4){
		ClipTex = 1 - screenPosNormal.x; 
	}
	float ClipAmount = ClipTex - _Amount;
	float Clip = 0;
	if (_Amount > 0)
	{
		if (ClipAmount <0)
		{
			Clip = 1; //clip(-0.1);
		
		}
		 else
		 {
		
			
		 }
	 }

	 
if (Clip == 1)
{
	fixed4 tex2 = tex2D(_MainTex2, IN.uv_MainTex2);
	o.Albedo = tex2.rgb ;
}

   
	//////////////////////////////////
	//
	o.Gloss = tex.a;
	o.Alpha = tex.a * _Color.a;
	o.Specular = _Shininess;
	
}



ENDCG
}

FallBack "Specular"
}
