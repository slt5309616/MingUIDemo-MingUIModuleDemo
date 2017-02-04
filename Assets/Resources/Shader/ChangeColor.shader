Shader "Custom/ChangeColor" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_addColor ("AddColor", Color) = (1,1,1,1)
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
		_lightColor ("LightColor", Color) = (0.47,0.47,0.47,1)


	    //_Shininess ("Shininess", Range (0.01, 1)) = 0.078125
		//_Gloss ("Gloss", Range (0.01, 1)) = 0.078125
		_Ks("KS", Float) = 128
	}
	SubShader {
				Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}
		LOD 200
		Lighting Off
		AlphaTest Greater [_Cutoff]
      CGPROGRAM
     // #pragma surface surf Lambert //finalcolor:mycolor
	  		//【1】光照模式声明：使用自定义的光照模式
      #pragma surface surf SimpleSpecular
	  fixed4 _addColor;
	  fixed4 _lightColor;
	  float _Cutoff; 
      sampler2D _MainTex;

	    //float _Shininess;
		//float _Gloss;
		float _Ks;
      struct Input {
          float2 uv_MainTex;
      };

	  half4 LightingSimpleSpecular (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) 
		{
			half3 h = normalize (lightDir + viewDir);

			half diff = max (0, dot (s.Normal, viewDir));

			//float nh = max (0, dot (s.Normal, h));
			//float spec = pow (nh, s.Specular*_Ks) * s.Gloss;//pow (nh, 48.0);

			half4 c;

			c.rgb =(s.Albedo * _lightColor.rgb * diff ) * (atten * 2);
			c.a = s.Alpha;
			return c;
		}

      void mycolor (Input IN, SurfaceOutput o, inout fixed4 color)
      {
          color *= _addColor;
      }

      void surf (Input IN, inout SurfaceOutput o) {
	  fixed4 tex  =tex2D (_MainTex, IN.uv_MainTex);
		  o.Albedo = tex.rgb;
		  o.Emission = _addColor.rgb;
		  o.Alpha = tex.a;
		  o.Gloss =100;
      }
      ENDCG
	} 
	FallBack "Diffuse"
}
