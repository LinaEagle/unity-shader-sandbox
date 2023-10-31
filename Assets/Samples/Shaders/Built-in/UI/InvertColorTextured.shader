Shader "UI/InvertColorTextured"
{
     Properties 
     {
        _MainTex ("Font Texture", 2D) = "" {}
        _Color ("Text Color", Color) = (1,1,1,1)
        _AlphaTest("Alpha Cutout", Range(0,1)) = 0.5
     }
     
     SubShader 
     {
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
        Lighting Off Cull Off ZWrite Off Fog { Mode Off }
        
        Pass 
        {
           Color [_Color]
           AlphaTest Greater [_AlphaTest]
           Blend SrcColor DstColor
           BlendOp Sub
           SetTexture [_MainTex] 
           { 
               combine previous, 
               texture * primary 
           }
            
/*            // Apply base texture
            SetTexture [_MainTex] {
                combine previous, texture
            }
            // Blend in the alpha texture using the lerp operator
            SetTexture [_MainTex] {
                combine texture lerp (texture) previous
            }*/
        }
     }
}
