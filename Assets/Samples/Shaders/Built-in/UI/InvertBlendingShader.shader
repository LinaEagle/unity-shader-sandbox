// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/InvertBlendingShader"
{
    Properties
    {
        _MainTex ("Font Texture", 2D) = "" {}
        _Color ("Tint Color", Color) = (1,1,1,1)
        _AlphaCutout ("AlphaCutout", Range(0,1)) = 0.5
    }
   
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        
        Blend OneMinusDstColor OneMinusSrcAlpha //invert blending, so long as FG color is 1,1,1,1
        BlendOp Add
       
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            uniform float4 _Color;

            #include "UnityCG.cginc"

            struct vertexInput
            {
                float4 vertex: POSITION;
                float4 color : COLOR;
                float2 uv : TEXCOORD0;
            };
 
            struct fragmentInput
            {
                float4 pos : SV_POSITION;
                float4 color : COLOR0;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _AlphaCutout;
 
            fragmentInput vert( vertexInput i )
            {
                fragmentInput o;
                o.pos = UnityObjectToClipPos(i.vertex);
                o.uv = TRANSFORM_TEX(i.uv, _MainTex);
                o.color = _Color;
                return o;
            }
 
            half4 frag( fragmentInput i ) : COLOR
            {
                float4 tex = tex2D(_MainTex, i.uv);
                clip((tex.a > _AlphaCutout) - _AlphaCutout);
                return i.color;
            }
 
            ENDCG
        }
    }
}
