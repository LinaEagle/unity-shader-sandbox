Shader "Custom/Unlit Healthbar Interpolated"
{
    Properties
    {
        _NormValue ("Normalized Value", Range (0,1)) = 0.5
        
        _EmptyColor("Empty Color", Color) = (1,0,0,1)
        _EmptyThreshold ("Empty Threshold", Range (0,1)) = 0.2
        
        _FullColor("Full Color", Color) = (0,1,0,1)
        _FullThreshold ("Full Threshold", Range (0,1)) = 0.8
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        
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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float _NormValue;
            float _EmptyThreshold;
            float _FullThreshold;
            half4 _EmptyColor;
            half4 _FullColor;

            fixed4 frag (v2f i) : SV_Target
            {
                if (_NormValue == 0)
                {
                    return _EmptyColor;
                }
                
                float colorT = _NormValue + (-0.2)*(_NormValue < _EmptyThreshold) + (0.2)*(_NormValue > _FullThreshold);
                fixed4 col = lerp(_EmptyColor, _FullColor, colorT);
                
                fixed4 t = step(_NormValue, i.uv.x);
                fixed4 black = fixed4(0,0,0,1);
                col = lerp(col, black, t);
                
                return col;
            }
            ENDCG
        }
    }
}
