Shader "PeterLu/OutlineShaderHorizontal"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		[Space(20)]
		[Header(Overlay Colors)]
		_OverlayHorizontal("Overlay Color Horizontal", Color) = (0,0,0,0)
		_OverlayVertical("Overlay Color Vertical", Color) = (0,0,0,0)
		[Space(20)]
		[Header(Outline Colors)]
		_OutlineColorHorizontal("Outline Color Horizontal", Color) = (0,0,0,0)
		_OutlineColorVertical("Outline Color Vertical", Color) = (0,0,0,0)

		_OutlineStrength("Outline Strength", Range(0.01, 0.3)) = 0.01

		_HorizontalNormalRange("Horizontal Range", float) = 0
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
				half3 worldNormal : TEXCOORD0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _OutlineColorHorizontal;
			fixed4 _OutlineColorVertical;

			float _HorizontalNormalRange;
			
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
				o.worldNormal = UnityObjectToWorldNormal(v.normal);


				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col;

				/*
				if(abs(1 - i.worldNormal.y) < _HorizontalNormalRange)
				{
					col = _OutlineColorHorizontal;
				}
				else
				{
					col = _OutlineColorVertical;
				}
				*/

				//col = float4(0, i.worldNormal.y, 0, 1);

				if(i.worldNormal.y > _HorizontalNormalRange)
				{
					col = _OutlineColorHorizontal;
				}
				else{
					col = _OutlineColorVertical;
				}

				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}

		/*
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
               
			float4 _OverlayHorizontal;
			float4 _OverlayVertical;

			float _HorizontalNormalRange;
     
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
			fixed4 col;

                if(abs(1 - i.normal.y) < _HorizontalNormalRange)
				{
					 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.GrabUV)) + _OverlayHorizontal;
				}
				else
				{
					 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.GrabUV)) + _OverlayVertical;
				}

				return col;
            }
            ENDCG
        }
		*/
	}
}
