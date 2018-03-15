Shader "Custom/Geometry/SuperBasic"
{
	// YOU HAVE TO INITIALZE EVERY APPENDED OBJECT EVERY TIME
	//
	// YOU ALSO HAVE TO ACCEPT THE SAME TOPOLOGY THAT YOUR MESHES USE
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
 
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Cull Off
 
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma geometry geom
 
            #include "UnityCG.cginc"
 
            struct v2g
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
 
            struct g2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };
 
            sampler2D _MainTex;
            float4 _MainTex_ST;
           
            v2g vert (appdata_base v)
            {
                v2g o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }
 
            [maxvertexcount(6)]
            void geom(triangle v2g IN[3], inout TriangleStream<g2f> tristream)
            {
            	
                g2f o;

            	o.pos = IN[1].vertex;
            	o.uv = IN[1].uv;
                tristream.Append(o);
                o.pos = IN[0].vertex;
            	o.uv = IN[0].uv;
                tristream.Append(o);

				o.pos = IN[2].vertex;
            	o.uv = IN[2].uv;
                tristream.Append(o);

                tristream.RestartStrip();


            }
           
            fixed4 frag (g2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}