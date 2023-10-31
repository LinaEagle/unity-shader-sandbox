Shader "Unlit/GrabPassInvert"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white"{}
        _Color ("Color", Color) = (1,1,1,1)
        [Toggle] _UseAlphaCutout ("UseAlphaCutout", Float) = 0
        _AlphaCutout ("Alpha Cutout", Range(0,1)) = 0
    }
    SubShader
    {
        // Draw after all opaque geometry
        Tags { "Queue" = "Transparent" "RenderType"="Transparent" }
        
        Blend SrcAlpha OneMinusSrcAlpha

        // Grab the screen behind the object into _BackgroundTexture
        GrabPass
        {
            "_BackgroundTexture"
        }

        // Render the object with the texture generated above, and invert the colors
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f
            {
                float4 grabPos : TEXCOORD1;
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert(appdata_base v) {
                v2f o;
                // use UnityObjectToClipPos from UnityCG.cginc to calculate 
                // the clip-space of the vertex
                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                
                // use ComputeGrabScreenPos function from UnityCG.cginc
                // to get the correct texture coordinate
                o.grabPos = ComputeGrabScreenPos(o.pos);
                return o;
            }

            sampler2D _BackgroundTexture;
            float _AlphaCutout;
            float _UseAlphaCutout;
            float4 _Color;

            float4 frag(v2f i) : SV_Target
            {
                float4 bgcolor = tex2Dproj(_BackgroundTexture, i.grabPos);
                float4 tex = tex2D(_MainTex, i.uv);
                float4 invertedColor = 1 - bgcolor;
                invertedColor.a = tex.a;
                if (_UseAlphaCutout)
                {
                    invertedColor.a = step(_AlphaCutout, invertedColor.a);
                }
                return invertedColor * _Color;
            }
            ENDCG
        }
    }
}