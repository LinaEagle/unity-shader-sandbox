Shader "Custom/Unlit Healthbar Interpolated"
{
    Properties
    {
        _NormalizedValue ("Normalized Value", Range (0,1)) = 0.5
        
        _EmptyColor("Empty Color", Color) = (1,0,0,1)
        _EmptyThreshold ("Empty Threshold", Range (0,1)) = 0.2
        
        _FullColor("Full Color", Color) = (0,1,0,1)
        _FullThreshold ("Full Threshold", Range (0,1)) = 0.8
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
            half4 _EmptyColor;
            half4 _FullColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                if (_NormalizedValue == 0)
                {
                    return _EmptyColor;
                }
                
                fixed4 col = lerp(_EmptyColor, _FullColor, _NormalizedValue);
                fixed4 t = step(_NormalizedValue, i.uv.x);
                fixed4 black = fixed4(0,0,0,1);
                col = lerp(col, black, t);
                
                return col;
            }
            ENDCG
        }
    }
}
