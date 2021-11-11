#ifndef RECTANGLE_HLSLINCLUDE
#define RECTANGLE_HLSLINCLUDE

void Rectangle_float(float Width, float Height, float x, float y, out float result)
{
    result = step(abs(x), Width) * step(abs(y), Height);
}

#endif