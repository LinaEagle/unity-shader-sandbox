float _Height;
float _Width;

float rectangle(float2 c, float2 p, float w, float h)
{    
    return step(abs(c.x - p.x), w * 0.5) * step(abs(c.y - p.y), h * 0.5);               
}