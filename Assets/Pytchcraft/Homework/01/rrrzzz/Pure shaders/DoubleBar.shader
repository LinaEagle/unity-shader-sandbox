Shader "Homework/rrrzzz/DoubleBar"
{
    Properties
    {
        _FirstFilledFraction ("FirstFilledFraction", Range(0, 1)) = 0 
        _Height ("Height", Range(0, 1)) = 0 
        _Width ("Width", Range(0, 2)) = 0 
        _ColorLeft ("ColorLeft", Color) = (0,0,0,0)
        _ColorRight ("ColorRight", Color) = (0,0,0,0)
        _BgColor ("BgColor", Color) = (0,0,0,1)
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

            #include "BoilerplatePixelDrawing.cginc"
            #include "RectangleDrawing.cginc"
            
            fixed4 _ColorLeft;
            fixed4 _ColorRight;
            fixed4 _BgColor;
            float _FirstFilledFraction;    

            fixed4 frag (v2f i) : SV_Target
            {
                float startX = -_Width * 0.5;
                float colorEdgeX = startX + _Width * _FirstFilledFraction;
                float colorStep = step(colorEdgeX, i.uv.x);
                fixed4 fillColor = lerp(_ColorLeft, _ColorRight, colorStep);

                fixed4 col = lerp(_BgColor, fillColor, rectangle(float2(0,0), i.uv, _Width, _Height));
                return col;
            }           
            
            ENDCG
        }
    }
}
