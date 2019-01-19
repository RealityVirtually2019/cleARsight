Shader "PeterLu/OutlineShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Overlay("_Overlay", Color) = (0,0,0,0)
		_OutlineColor("Outline Color", Color) = (0,0,0,0)
		_OutlineStrength("Outline Strength", Range(0.01, 0.3)) = 0.01
		_FalloffThreshould ("Falloff Threshould", Range(0,9)) = 5
		_FalloffPower("Falloff power", Range(0,10)) = 5
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "IgnoreProjector" = "True" "Queue"="Transparent"}
		LOD 100
		GrabPass {"_GrabTexture"}

		//This pass renderes the outline and it renders after the above pass by extruding all the faces and cull the front side
		Pass
		{
			Cull Front
			ZWrite On 
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
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _OutlineColor;
			
			float _OutlineStrength;
			float _FalloffThreshould;
			float _FalloffPower;
			uniform Vector camPos; 

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);

				//find the offset according to normal direction
				float3 norm   = normalize(mul ((float3x3)UNITY_MATRIX_IT_MV, v.normal));
				float3 offset = TransformViewToProjection(norm.xyz);
				
				//extrude by the offset
				o.vertex.xyz += offset * _OutlineStrength;
				
				//change the vertex color
				o.color = _OutlineColor;

				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				//returns the outline color with fog
				fixed4 col = _OutlineColor;
				
				float alphaValue;
				float dist = distance(i.vertex, camPos);

				if(dist > _FalloffThreshould)
				{
					alphaValue = saturate(abs(_FalloffThreshould - dist) / _FalloffPower);
				}

				col.a = alphaValue;

				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}

		Pass {
            Name "GrabOffset"
            Cull Back
            ZWrite Off
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
               
			float4 _Overlay;
     
            struct v2f {
                float4 pos : POSITION;
                float2 texcoord : TEXCOORD0;
                float4 GrabUV : TEXCOORD1;
                float3 normal : NORMAL;
            };
     
			

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos (v.vertex);
                o.texcoord = v.texcoord;
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.GrabUV = ComputeGrabScreenPos(o.pos);
                   
                return o;
            }
               
     
            fixed4 frag (v2f i) : COLOR
            {
                
                fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.GrabUV)) + _Overlay;
				return col;
            }
            ENDCG
        }
	}
}
