Shader "Unlit/LostShaderVirginity"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _CenterX ("Center X", Float) = 0
        _CenterY ("Center Y", Float) = 0
        _Radius ("Radius", Float) = 2
        _CircleColor ("Circle Color", Color) = (1, 1, 1)
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct startData
            {
                float4 localPosition : POSITION;
                // float3 localNormal : NORMAL;
            };

            struct v2f
            {
                float4 svPosition : SV_POSITION;
                float3 localPosition : TEXCOORD0;
                float3 worldPosition : TEXCOORD1;
            };

            half _CenterX;
            half _CenterY;
            half _Radius;
            fixed3 _CircleColor;

            half _WorldPosMlt;

            v2f vert(startData input)
            {
                v2f output;
                
                // localPosition * localToWorld * worldToView * viewToScreen
                output.svPosition = UnityObjectToClipPos(input.localPosition);
                output.localPosition = input.localPosition.rgb;
                output.worldPosition = mul(unity_ObjectToWorld, input.localPosition) * _WorldPosMlt;

                return output;
            }

            fixed3 frag(v2f input) : SV_TARGET
            {
                fixed distance = sqrt(pow(input.worldPosition.x + _CenterX, 2) + pow(input.worldPosition.z + _CenterY, 2));
                fixed circle = step(distance, _Radius);
                fixed3 circleColor = lerp(0, _CircleColor, circle);
                return circleColor;
            }
            
            ENDCG
        }
    }
}
