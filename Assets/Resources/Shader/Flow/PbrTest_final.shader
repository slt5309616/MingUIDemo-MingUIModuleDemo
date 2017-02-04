Shader "Custom/reflect new ops3" {
	Properties{
	_MainTex("Base (RGB)", 2D) = "white" {}
	_Maintint("Main Color", Color) = (1, 1, 1, 1)
	_Mask("Base (RGB)", 2D)= "white" {}
		_Cubemap("CubeMap", CUBE) = ""{}
	_SC("Specular Color", Color) = (1, 1, 1, 1)
		_GL("gloss", Range(0, 1)) = 0.5
		_nMips("nMipsF", Range(0, 5)) = 0.5
		_ReflAmount("Reflection Amount", Range(0.01, 1)) = 0.5
}
	SubShader{
		pass{//平行光的的pass渲染
		Tags{ "LightMode" = "ForwardBase" }
		Cull Back
		//AlphaTest Greater 0.5
		//Blend One One
			CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"

			float4 _LightColor0;
		samplerCUBE _Cubemap;
		float4 _SC;
		float _GL;
		float4 _Maintint;
		float _nMips;
		float _ReflAmount;
		uniform sampler2D _MainTex;
		uniform sampler2D _Mask;
		float4 _MainTex_ST;
		struct v2f {
			float4 pos : SV_POSITION;
			float2 uv_MainTex : TEXCOORD0;
			float3 lightDir : TEXCOORD1;
			float3 viewDir : TEXCOORD2;
			float3 normal : TEXCOORD3;

		};

		v2f vert(appdata_full v) {
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);//切换到世界坐标
			o.normal = v.normal;
			o.lightDir = ObjSpaceLightDir(v.vertex);
			o.viewDir = ObjSpaceViewDir(v.vertex);
			o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
			return o;
		}
#define PIE 3.1415926535	


		float4 frag(v2f i) :COLOR
		{
			float3 viewDir = normalize(i.viewDir);
			float3 lightDir = normalize(i.lightDir);
			float3 H = normalize(lightDir + viewDir);
			float3 N = normalize(i.normal);
			float _SP = pow(8192, _GL);
			float d = (_SP + 2) / (8 * PIE) * pow(dot(N, H), _SP);
			//	float f = _SC + (1 - _SC)*pow((1 - dot(H, lightDir)), 5);
			float f = _SC + (1 - _SC)*pow(2, -10 * dot(H, lightDir));
			float k = min(1, _GL + 0.545);
			float v = 1 / (k* dot(viewDir, H)*dot(viewDir, H) + (1 - k));

				float all = d*f*v;
			//	float3 refDir = N - lightDir / 2;//H
				float3 refDir = reflect(-viewDir,N);
				float3 ref = texCUBElod(_Cubemap, float4(refDir, _nMips - _GL*_nMips)).rgb;//* _ReflAmount;
			float3 c = tex2D(_MainTex, i.uv_MainTex);
			float3 diff = dot(lightDir, N);
		//	diff /= PIE;
			diff = (1 - all)*diff;

		//	return float4(c *(diff + all), 1)  * _LightColor0;
		//	return float4(lerp(c, ref, _ReflAmount) *(diff*_Maintint + all), 1)*_LightColor0;
		//	return float4(ref*((_Maintint+0.2) * (1 - dot(lightDir, N))) + c *(diff*_Maintint + all), 1)*_LightColor0;
		//	return float4(lerp(c, ref, _ReflAmount) *(diff*(_Maintint + 0.2)* (1 - dot(lightDir, N)) + all), 1)*_LightColor0;

		//float4 final = float4(c *(diff + all), 1)  * _LightColor0;
		float4 final = float4(lerp(c, ref, _ReflAmount) *(diff*_Maintint + all), 1)*_LightColor0;
		//float4 final = float4(ref*((_Maintint+0.2) * (1 - dot(lightDir, N))) + c *(diff*_Maintint + all), 1)*_LightColor0;
		//float4 final = float4(lerp(c, ref, _ReflAmount) *(diff*(_Maintint + 0.2)* (1 - dot(lightDir, N)) + all), 1)*_LightColor0;

		return final;// * tex2D(_Mask, i.uv_MainTex) * tex2D(_MainTex, i.uv_MainTex);
		}
		ENDCG
	}
	}
}