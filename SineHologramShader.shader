Shader "Unlit/HologramShader"
{
	Properties
	{
		// Essentially public variable definitions
		// Notice no semicolons
		
		_MainTex ("Texture", 2D) = "white" {}
		_TintColor ("Tint Color", Color) = (1, 1, 1, 1)

		// If you set alpha too high, stuff that is supposed to render in back can render in front
		_Transparency ("Transparency", Range(0.0, 0.5)) = 0.25

		_CutoutThresh ("Cutout Threshold", Range(0.0, 1.0)) = 0.2
		_Distance ("Distance", Float) = 1.0
		_Amplitude ("Amplitude", Float) = 1.0
		_Speed ("Speed", Float) = 1.0
		_Amount ("Amount", Float) = 1.0
	}
	SubShader
	{
		// Say where in render order queue to put this object
		Tags { "Queue" = "Transparent" "RenderType"="Transparent" }
		LOD 100

		// Don't render into depth buffer - Decides whether pixels from this are written to depth buffer
		ZWrite Off

		// Specifies how we are going to blend (with alpha channel)
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			// Declaring C for Graphics program
			CGPROGRAM

			// Declaring functions
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			// Struct to hold what is passed from vertex to fragment shader
			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			// Getting properties into subshader
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _TintColor;
			float _Transparency;
			float _CutoutThresh;

			float _Distance;
			float _Amplitude;
			float _Speed;
			float _Amount;

			// Vertex shader function
			v2f vert (appdata v)
			{
				v2f o;

				// Changes x values sinosoidally by applying wave function
				v.vertex.x += sin(_Time.y * _Speed + v.vertex.y * _Amplitude) * _Distance * _Amount;
				// Translates from local space to clip space
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			// Pixel shader function (called fragment shader)
			fixed4 frag (v2f i) : SV_Target
			{
				// Get color of pixel on screen by sampling the texture and uv data for model
				// We are also applying a tint color here
				fixed4 col = tex2D(_MainTex, i.uv) + _TintColor;
				col.a = _Transparency;

				// This cuts out any pixels with red values under threshold
				// Could also say (col.r < _CutoutThresh) discard;
				clip(col.r - _CutoutThresh);

				return col;
			}
			ENDCG
		}
	}
}