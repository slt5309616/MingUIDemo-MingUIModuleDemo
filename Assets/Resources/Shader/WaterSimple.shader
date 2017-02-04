Shader "Tasharen/WaterSimple"
{
	Properties
	{
		_WaterTex ("Normal Map (RGB), Foam (A)", 2D) = "white" {}
		_SprayTex ("Spray", 2D) = "white" {}
		_ReflectionTex ("Reflection", 2D) = "white" { TexGen ObjectLinear }
		_Cube ("Skybox", Cube) = "_Skybox" { TexGen CubeReflect }
		_Color0 ("Shallow Color", Color) = (1,1,1,1)
		_Color1 ("Deep Color", Color) = (0,0,0,0)
		_Specular ("Specular", Color) = (0,0,0,0)
		_Shininess ("Shininess", Range(0.01, 1.0)) = 1.0
		_Tiling ("Tiling", Range(2.5, 25)) = 0.25
		_ReflectionTint ("Reflection Tint", Range(0.0, 1.0)) = 0.8
		_InvRanges ("Inverse Alpha, Depth and Color ranges", Vector) = (1.0, 0.17, 0.17, 0.0)
		_Direction("Water Direction", Range(0.0, 360.0)) = 0.0
		_Speed("Water Speed", Range(0, 0.2)) = 0.01
		_depth("Depth",float) =0
		_depth2("Depth2",float) =0
	}
	
	//==============================================================================================
	// Common functionality
	//==============================================================================================

	CGINCLUDE
	#pragma target 3.0
	#include "UnityCG.cginc"
	
	half4 _Color0;
	half4 _Color1;
	half4 _Specular;
	float _Shininess;
	float _Tiling;
	float _ReflectionTint;
	half4 _InvRanges;
	float _Direction;
	float _Speed;
	float _depth;
	float _depth2;
	
	sampler2D _CameraDepthTexture;
	sampler2D _WaterTex;
	sampler2D _SprayTex;
	
	half4 LightingPPL (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
	{
		half3 nNormal = normalize(s.Normal);
		half shininess = s.Gloss * 250.0 + 4.0;
	
	#ifndef USING_DIRECTIONAL_LIGHT
		lightDir = normalize(lightDir);
	#endif
		// Phong shading model
		half reflectiveFactor = max(0.0, dot(-viewDir, reflect(lightDir, nNormal)));
	
		// Blinn-Phong shading model
		//half reflectiveFactor = max(0.0, dot(nNormal, normalize(lightDir + viewDir)));
	
		half diffuseFactor = max(0.0, dot(nNormal, lightDir));
		half specularFactor = pow(reflectiveFactor, shininess) * s.Specular;
	
		half4 c;
		c.rgb = (s.Albedo * diffuseFactor + _Specular.rgb * specularFactor) * _LightColor0.rgb;
		c.rgb *= (atten * 2.0);
		c.a = s.Alpha;
		return c;
	}
	ENDCG
	
	//==============================================================================================
	// Reflection and refraction
	//==============================================================================================

	SubShader
	{
		Tags { "Queue" = "Transparent-10" }
		
		GrabPass
		{
			Name "BASE"
			Tags { "LightMode" = "Always" }
		}

		Blend Off 
		ZTest LEqual

		CGPROGRAM
		#pragma surface surf PPL vertex:vert noambient
		
		sampler2D _GrabTexture : register(s0);
		sampler2D _ReflectionTex;
		
		uniform half4 _GrabTexture_TexelSize;
		
		struct Input
		{
			//float4 position  : POSITION;
			float3 worldPos  : TEXCOORD2;	// Used to calculate the texture UVs and world view vector
			float4 proj0   	 : TEXCOORD3;	// Used for depth and reflection textures
			float4 proj1	 : TEXCOORD4;	// Used for the refraction texture
			float2 uv_WaterTex;
		};
		
		void vert (inout appdata_full v, out Input o)
		{
		 UNITY_INITIALIZE_OUTPUT(Input,o);
			o.worldPos = v.vertex.xyz;
			 float4 position = mul(UNITY_MATRIX_MVP, v.vertex);
			o.proj0 = ComputeScreenPos(position);
			COMPUTE_EYEDEPTH(o.proj0.z);
		
			o.proj1 = o.proj0;
			#if UNITY_UV_STARTS_AT_TOP
			o.proj1.y = (position.w - position.y) * 0.5;
			#endif
		}
		//todo 下面的几个lod的水流方向还没支持
		void surf (Input IN, inout SurfaceOutput o)
		{
			// Calculate the world-space view direction (Y-up)
			// We can't use IN.viewDir because it takes the object's rotation into account, and the water should not.
			float3 worldView = (IN.worldPos - _WorldSpaceCameraPos);
			
			// Calculate the object-space normal (Z-up)
			float time = _Time.y * _Speed;
			half2 tiling = _Tiling * IN.uv_WaterTex;// _Tiling * IN.worldPos.zx;
			float radian = radians(_Direction);
			float2 uv = float2(cos(radian) - sin(radian), sin(radian) + cos(radian)) * time + tiling;
			half4 uvNoise = tex2D(_WaterTex, uv) * 0.2;
			half4 nmap = tex2D(_WaterTex, tiling + uvNoise.xy);
			o.Normal = nmap.xyz * 2.0 - 1.0;

			// World space normal (Y-up)
			half3 worldNormal = o.Normal.xzy;
			worldNormal.z = -worldNormal.z;
		
			// Calculate the depth difference at the current pixel
			float depth = tex2Dproj(_CameraDepthTexture, IN.proj0).r;
			depth = LinearEyeDepth(depth);
			depth -= IN.proj0.z;
		
			// Calculate the depth ranges (X = Alpha, Y = Color Depth)
			half3 ranges = saturate(_InvRanges.xyz * depth);
			ranges.y = 1.0 - ranges.y;
			ranges.y = lerp(ranges.y, ranges.y * ranges.y * ranges.y, 0.5);
		
			// Calculate the color tint
			half4 col;
			col.rgb = lerp(_Color1.rgb, _Color0.rgb, ranges.y);
			col.a = ranges.x;

			
			// Initial material properties
			o.Alpha = col.a;
			o.Specular = col.a;
			o.Gloss = _Shininess;
		
			// Dot product for fresnel effect
			half fresnel = sqrt(1.0 - dot(-normalize(worldView), worldNormal));

			// High-quality reflection uses the dynamic reflection texture
			IN.proj0.xy += o.Normal.xy * 0.5;
			half3 reflection = tex2Dproj(_ReflectionTex, IN.proj0).rgb;
			reflection = lerp(reflection * col.rgb, reflection, fresnel * _ReflectionTint);

			// High-quality refraction uses the grab pass texture
			IN.proj1.xy += o.Normal.xy * _GrabTexture_TexelSize.xy * (20.0 * IN.proj1.z * col.a);
			half3 refraction = tex2Dproj(_GrabTexture, IN.proj1).rgb;
			refraction = lerp(refraction, refraction * col.rgb, ranges.z);

			// Color the refraction based on depth
			refraction = lerp(lerp(col.rgb, col.rgb * refraction, ranges.y), refraction, ranges.y);

			// The amount of foam added (35% of intensity so it's subtle)
			half foam = nmap.a * (1.0 - abs(col.a * 2.0 - 1.0)) * 0.35;

			// Always assume 20% reflection right off the bat, and make the fresnel fade out slower so there is more refraction overall
			fresnel *= fresnel * fresnel;
			fresnel = (0.8 * fresnel + 0.2) * col.a;

			// Calculate the initial material color
			o.Albedo = lerp(refraction, reflection, fresnel) + foam;
		
			// Calculate the amount of illumination that the pixel has received already
			// Foam is counted at 50% to make it more visible at night
			fresnel = min(1.0, fresnel + foam * 0.5);
			o.Emission =o.Albedo * (1.0 - fresnel);
		
			// Set the final color
		#ifdef USING_DIRECTIONAL_LIGHT
			o.Albedo *= fresnel;
		#else
			// Setting it directly using the equals operator causes the shader to be "optimized" and break
			o.Albedo = lerp(o.Albedo.r, 1.0, 1.0);
		#endif
		half4 SprayColor = tex2D(_SprayTex, uv);
		if(depth>0 && _depth>depth){
		float temp =(_depth- depth)/_depth2;
		if(depth<_depth2){
		temp =depth/_depth2;
		}
		o.Albedo =lerp(o.Albedo, SprayColor.rgb, temp);;
		}
		}
		ENDCG
		}
	Fallback Off
}
