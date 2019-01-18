Shader "PeterLu/OutlineShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Tint("Tint", Color) = (0,0,0,0)
		_OutlineColor("Outline Color", Color) = (0,0,0,0)
		_OutlineStrength("Outline Strength", Range(0.01, 0.3)) = 0.01
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "IgnoreProjector" = "True" "Queue"="Transparent"}
		LOD 100
		GrabPass {"_GrabTexture"}
		//This pass is the base rendering pass, works like a normal unlit shader
		/*Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			fixed4 _Tint;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv) * _Tint;
					clip(col);
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
		*/

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
                
                fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.GrabUV));
				return col;
            }
            ENDCG
        }
	}
}
