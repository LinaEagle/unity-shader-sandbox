Shader "Custom/Circle"
{
    Properties
    {
        _Radius ("Normalized Radius", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { 
            "RenderType"="Transparent"
            "Queue"="Transparent"}
        
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

            float _Radius;

            fixed4 frag (v2f i) : SV_Target
            {
                float2 centeredUV = i.uv*2 -1;
                float radialDistance = length(centeredUV);
                float circle = step(float4(radialDistance.xxx, 1), _Radius);
                
                return circle;
            }
            ENDCG
        }
    }
}
