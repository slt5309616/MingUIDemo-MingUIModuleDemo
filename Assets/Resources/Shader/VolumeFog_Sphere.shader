Shader "KEffect/Volume Fog Sphere"
{
    Properties
    {
        _Color ("Main Color", Color) = (1,1,1,1)
        _MainTex ("Base (RGB)", 2D) = "white" {}
		_RadiusSqr ("Radius", Float) = 1.0
        _TextureData ("Texture Speed (X,Y,Z), Texture Scale (W)", Vector) = (10,-0.1,0,1)
        _Visibility ("Visibility", Float) = 1.0
        _BIsForwardLighting ("Is Forward Lighting", Float) = 0
    }
    
    SubShader
    {
        Tags { "Queue"="Overlay-1" "IgnoreProjector"="True" "RenderType"="Transparent" }
        //Blend Off                           // No Blend
        Blend SrcAlpha OneMinusSrcAlpha     // Alpha blending


        Cull Front
        Lighting Off
        ZWrite Off
        ZTest Always
        Fog { Color (0,0,0,0) }
        LOD 200
	
        Pass
        {	
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma target 3.0
            sampler2D _MainTex;
            sampler2D _CameraDepthTexture;
            float4 _Color;


            //检测Sphere碰撞点
            inline bool IntersectSphere(float3 rayOrigin, float3 rayDirection, float radius, inout float t1, inout float t2)
            {
				//(r*cosA) * (r*cosA)
                float tca = dot(rayOrigin, -rayDirection);

				//(r*sinA) * (r*sinA)
                float d2 = dot(rayOrigin, rayOrigin) - tca * tca;

				//判断是否相离
                if (d2 > radius) { return 0.0f; }
                
				//算出光源到两个相交点的距离：t1,t2
				float thc = sqrt(radius - d2);
                t2 = tca - thc;
                t1 = tca + thc;

                return 1.0f;
            }

            struct VSOutput
            {
                float4 vPos         : SV_POSITION;
                float3 vWorldPos    : TEXCOORD0;
                float4 vScreenPos   : TEXCOORD1;
                float3 vLocalPos    : TEXCOORD2;
                float3 vViewPos     : TEXCOORD3;
                float3 vLocalCamPos : TEXCOORD4;
            };

            half _RadiusSqr;
            float4 _TextureData;
            float _Visibility;
            float _BIsForwardLighting;

            VSOutput vert (appdata_full IN)
            {
                VSOutput OUT;

                OUT.vLocalPos = IN.vertex.xyz;
                OUT.vWorldPos.xyz = mul((float4x4)_Object2World, float4(IN.vertex.xyz, 1.0f)).xyz;
                OUT.vViewPos = mul((float4x4)UNITY_MATRIX_MV, float4(IN.vertex.xyz, 1.0f)).xyz;
                OUT.vLocalCamPos = mul((float4x4)_World2Object, (float4(_WorldSpaceCameraPos, 1.0f))).xyz;
                OUT.vPos = mul(UNITY_MATRIX_MVP, IN.vertex);
                OUT.vScreenPos = ComputeScreenPos(OUT.vPos);
      
                return OUT;
            }

            float4 frag (VSOutput IN) : COLOR
            {
                float3 eyeDirectionWorld = normalize(IN.vWorldPos - _WorldSpaceCameraPos);
                float3 eyeDirectionLocal = normalize(IN.vLocalPos - IN.vLocalCamPos);

                float3 rayOrigin = IN.vLocalCamPos;
                float3 rayDirection = eyeDirectionLocal;
                float t1, t2;
				t1 = t2 = 0;

                float bValidIntersection = IntersectSphere(rayOrigin, rayDirection, _RadiusSqr, t1, t2);

                t1 *= step(0, t1);
                t2 *= step(0, t2);

                //获得该像素点的深度
                float2 screenUV = IN.vScreenPos.xy / IN.vScreenPos.w;
                float4 depthTexture = tex2D(_CameraDepthTexture, screenUV);
                float uniformDistance = DECODE_EYEDEPTH(depthTexture.r);

                float3 viewEyeDirection = normalize(IN.vViewPos);
                float scaleFactor = (uniformDistance / viewEyeDirection.z);
                float distanceToDepthFragment = length(viewEyeDirection * scaleFactor);

                // 重新计算最近最远点，部分被遮挡了（depth）
                float tFar = max(t1, t2);
                float tNear = min(t1, t2);

                tFar = min(tFar, distanceToDepthFragment);
                tNear = min(tNear, distanceToDepthFragment);

                float intensity = 0;
                int sampleCount = 20;
                float invSampleCount = 1.0f/(float)sampleCount;
                float sampleRange = tFar - tNear;
                float sampleStep = sampleRange * invSampleCount;
                float totalUniformIntensity = pow(saturate(sampleRange*sampleRange / _Visibility), 1);
				

				//一步步计算雾的浓度（tSample = tNear + (sampleStep * (float)s);）
                for(int s=0; s<sampleCount; s++)
                {
                    float tSample = tNear + (sampleStep * (float)s);
                    float3 samplePosWorld = _WorldSpaceCameraPos + (eyeDirectionWorld * tSample);
                    float3 samplePosLocal = IN.vLocalCamPos + (eyeDirectionLocal * tSample);

					//贴图的位移和大小
                    half phaseX = _Time.y * _TextureData.x;
                    half phaseY = _Time.y * _TextureData.y;
                    half phaseZ = _Time.y * _TextureData.z;
                    float2 xyOffset = float2(phaseX, phaseY);
                    float2 zyOffset = float2(phaseZ, phaseY);

                    float scale = _TextureData.w;
                    
					float noiseValue = tex2D(_MainTex, samplePosWorld.xy*scale + xyOffset).r + tex2D(_MainTex, samplePosWorld.zy*scale + zyOffset).r;

                    // 偏移..一定距离看不到？？
                    //float distanceAttenuation = 1.0f - saturate(tSample / 50.0f);

                    // 计算雾的浓度
                    intensity += (invSampleCount * noiseValue);
					//intensity += (invSampleCount * noiseValue) * distanceAttenuation * distanceAttenuation;
                }

				//。。。。
                intensity *= totalUniformIntensity;
				//intensity *= cap;
				//intensity *= clamp(-IN.vLocalPos.y*10-(_StartFade*10-1),minClamp,1);
				//intensity *= clamp(pow(falloffRange,_FalloffPower)*_Falloff,1,1000000);

                return float4(_Color.rgb, intensity * _Color.a);
            }
            ENDCG
        }
	} 
}
