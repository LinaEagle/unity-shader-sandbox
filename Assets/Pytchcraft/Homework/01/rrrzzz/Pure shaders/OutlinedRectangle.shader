Shader "Homework/rrrzzz/OutlinedRectangle"
{
    Properties
    {
        _Height ("Height", Range(0, 2)) = 0 
        _Width ("Width", Range(0, 2)) = 0 
        _OutlineSize ("OutlineSize", Range(0, 1)) = 0 
        _BgColor ("BgColor", Color) = (0,0,0,1)
        _MainColor ("MainColor", Color) = (0,0,0,1)
        _OutlineColor ("OutlineColor", Color) = (0,0,0,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Blend SrcAlpha OneMinusSrcAlpha
        
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            
            #include "BoilerplatePixelDrawing.cginc"
            #include "RectangleDrawing.cginc"

            float _OutlineSize;
            fixed4 _BgColor;
            fixed4 _MainColor;
            fixed4 _OutlineColor;

            fixed4 frag (v2f i) : SV_Target
            {
                float mainRectangle = rectangle(float2(0,0), i.uv, _Width, _Height);
                float outline = rectangle(float2(0,0), i.uv, _Width + _OutlineSize, _Height + _OutlineSize);
                
                fixed4 color = lerp(_BgColor, _OutlineColor, outline);
                color = lerp(color, _MainColor, mainRectangle);
                return color;
            }
            ENDCG
        }
    }
}
