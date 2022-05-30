Shader "Custom/Unlit Healthbar Textured"
{
    Properties
    {
        [NoScaleOffset] _MainTex ("Texture", 2D) = "white" {}
        _NormValue ("Normalized Value", Range (0,1)) = 0.5
        _EmptyThreshold ("Empty Threshold", Range (0,1)) = 0.2
        _FullThreshold ("Full Threshold", Range (0,1)) = 0.8
        _PulseSpeed ("Pulse Speed", Float) = 10
    }
    SubShader
    {
        Tags { 
            "RenderType"="Transparent" 
            "Queue"="Transparent"
            }
        
        Blend SrcAlpha OneMinusSrcAlpha

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

            sampler2D _MainTex;
            float _NormValue;
            float _EmptyThreshold;
            float _FullThreshold;
            float _PulseSpeed;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 clear = fixed4(0,0,0,0);
                fixed4 color = tex2D(_MainTex, float2(_NormValue, i.uv.y));
                
                if (_NormValue == 0)
                {
                    return tex2D(_MainTex, float2(0.1, i.uv.y));
                }

                if (_NormValue < _EmptyThreshold)
                {
                    // pulse on low
                    fixed pulse = sin(i.uv.x - _Time.y * _PulseSpeed);
                    color.a = pulse;
                }
                
                // cull bar
                float t = step(_NormValue, i.uv.x);
                color = lerp(color, clear, t);
                
                return color;
            }
            ENDCG
        }
    }
}
