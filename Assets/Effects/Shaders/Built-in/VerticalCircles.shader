Shader "Custom/VerticalCircles"
{
    Properties
    {
        _ColorA ("Color A", Color) = (1,1,1,1)
        _ColorB ("Color B", Color) = (1,1,1,1)
        _ColorTransition ("Color Transition", Range(0,1)) = 0
        _SpeedFactor("SpeedFactor", Float) = 0.01
        _WaveAmplitude("Wave Amplitude", Float) = 10
    }
    SubShader
    {
        Tags { 
            "RenderType"="Transparent" 
            "Queue"="Transparent"
            }
        
        Cull off
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
                float3 normals : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD1;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = v.normals;
                return o;
            }

            float4 _ColorA;
            float4 _ColorB;
            float1 _SpeedFactor;
            float1 _WaveAmplitude;
            float _ColorTransition;

            fixed4 frag (v2f i) : SV_Target
            {
                // cull top and bottom
                float1 cullTop = abs(i.normal.y) < 0.99;
                // make wave
                float1 wave = sin((i.uv.y -_Time.y * _SpeedFactor) * _WaveAmplitude) * 0.5 + 0.5;
                // fade wave from bottom to top
                wave *= 1-i.uv.y;

                // collect shape
                float1 alpha = cullTop * wave;

                fixed4 color = lerp(_ColorA, _ColorB, _ColorTransition);
                
                fixed4 output = fixed4(color.rgb, alpha);
                return output;
            }
            ENDCG
        }
    }
}
