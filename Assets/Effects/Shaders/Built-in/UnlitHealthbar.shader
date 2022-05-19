Shader "Custom/Unlit Healthbar"
{
    Properties
    {
        _NormalizedValue ("Normalized Value", Range (0,1)) = 0.5
        _FirstColor("First Color", Color) = (1,1,1,1)
        _SecondColor("Second Color", Color) = (0,0,0,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float _NormalizedValue;
            half4 _FirstColor;
            half4 _SecondColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = step(_NormalizedValue, i.uv.x);
                col = lerp(_FirstColor, _SecondColor, col);
                return col;
            }
            ENDCG
        }
    }
}
