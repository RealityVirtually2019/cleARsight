﻿// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "PeterLu/SimpleOutline"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}

		[Space(20)]
		[Header(Overlay Colors)]
		_OverlayHorizontal("Overlay Color Horizontal", Color) = (0,0,0,0)
		_OverlayUnderground("Overlay Color Underground", Color) = (0,0,0,0)
		
		[Space(20)]
		[Header(Outline Colors)]
		_OutlineColor("Outline Color", Color) = (0,0,0,0)

		_OutlineStrength("Outline Strength", Range(0, 0.1)) = 0.01
		_HorizontalNormalRange("Horizontal Range", float) = 0

		_FalloffDistance("FalloffDistance", Range(0, 10)) = 5
		_FalloffPower("Falloff Power", Range(0,15)) = 1

		[Space(50)]
		[Header(Holo Section)]
		_Color ("Base Color", Color) = (1,1,1,1)
		_HoloColor("Holo Color", Color) = (1,1,1,1)
		_HoloValue ("Holo Value", Range(0, 10)) = 1
		_HoloDistance ("Holo Distance", Range(0,1)) = 0.5
		_HoloDirection("Holo Direction", Vector) = (0,1,0,0)
		_EmissionMultiplier("Emission Multiplier", Float) = 1
		_Speed("Speed", Range(0,1)) = 0

			[Space(50)]
		_GroundLevel("Ground level", Float) = -1
		_CutOffLevel("Cutoff level", Float) = -1

	}
	SubShader
	{
		

		Tags { "RenderType"="Transparent" "IgnoreProjector" = "True" "Queue"="Transparent"}
		LOD 100
		GrabPass {"_GrabTexture"}

		//This pass renderes the outline and it renders after the above pass by extruding all the faces and cull the front side
		Pass
		{
			ZWrite Off 
            ColorMask rgb 
            Blend SrcAlpha OneMinusSrcAlpha
			Tags { "LightMode" = "Always" }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float4 color : COLOR;
				float3 worldPos : TEXCOORD0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			fixed4 _OutlineColor;
			
			float _FalloffDistance;
			float _FalloffPower;
			
			float _OutlineStrength;

			float _GroundLevel;
			float _CutOffLevel;

			uniform float4 _CamPos;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);

				o.worldPos = mul (unity_ObjectToWorld, v.vertex);
				//find the offset according to normal direction
				float3 norm   = normalize(mul ((float3x3)UNITY_MATRIX_IT_MV, v.normal));
				float3 offset = TransformViewToProjection(norm.xyz);
				
				//extrude by the offsets
				o.vertex.xyz += offset * _OutlineStrength;
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col;
				if(i.worldPos.y > _CutOffLevel)
				{
					if(i.worldPos.y > _GroundLevel)
					{
						col = _OutlineColor * pow(saturate(_FalloffDistance / distance(_CamPos, i.worldPos)), _FalloffPower);
					}
					else
					{
						col = (0, 0, 0, 0);
					}
				}
				else
				{
					col = (0, 0, 0, 0);
				}

				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}

		
		Pass {
            Cull Back
            ZWrite On
        	Blend Off
               
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
     
            #include "UnityCG.cginc"
     
            sampler2D _GrabTexture;
	    
			struct appdata {
			float4 vertex : POSITION;
			float2 texcoord : TEXCOORD0;
            float3 normal : NORMAL;
	    };
               
			float4 _OverlayHorizontal;
			float4 _OverlayUnderground;

			float _HorizontalNormalRange;
			float _HoloValue;
			float _HoloDistance;
			float _Speed;
			float _FalloffDistance;
			float _FalloffPower;
			float _GroundLevel;
			float _CutOffLevel;
			uniform float4 _CamPos;
			

			float4 _HoloDirection;
     
            struct v2f {
                float4 pos : POSITION;
                float2 texcoord : TEXCOORD0;
                float4 GrabUV : TEXCOORD1;
                float3 normal : NORMAL;
				float3 worldPos : TEXCOORD2;
            };
     
			

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos (v.vertex);
                o.texcoord = v.texcoord;
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.GrabUV = ComputeGrabScreenPos(o.pos);
				o.worldPos = mul (unity_ObjectToWorld, v.vertex);
                   
                return o;
            }
               
     
            fixed4 frag (v2f i) : COLOR
            {
				fixed4 col;
				
				float finalP = i.worldPos.x * _HoloDirection.x + i.worldPos.y * _HoloDirection.y + i.worldPos.z * _HoloDirection.z;
				
				if(i.worldPos.y > _CutOffLevel)
				{
					if(i.normal.y > _HorizontalNormalRange && i.worldPos.y > _GroundLevel)
					{
						if(frac((finalP + _Time.y * _Speed) * _HoloValue) > _HoloDistance)
						{
							col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.GrabUV)) + _OverlayHorizontal * pow(saturate(_FalloffDistance / distance(_CamPos, i.worldPos)), _FalloffPower);
						}
						else
						{
							col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.GrabUV));
						}
					}
					else if (i.normal.y > _HorizontalNormalRange && i.worldPos.y < _GroundLevel)
					{
						if (frac((finalP + _Time.y * _Speed) * _HoloValue) > _HoloDistance)
						{
							col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.GrabUV)) + _OverlayUnderground * pow(saturate(_FalloffDistance / distance(_CamPos, i.worldPos)), _FalloffPower);
						}
						else
						{
							col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.GrabUV));
						}
					}
					else
					{
						col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.GrabUV));
					}
				}
				else
				{
					col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.GrabUV));
				}
				
				
				
				//col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.GrabUV)) + saturate(_OverlayHorizontal * abs(i.normal.y)) + saturate(_OverlayVertical * i.normal.x);

				return col;
            }
            ENDCG
        }
		
	}
}
