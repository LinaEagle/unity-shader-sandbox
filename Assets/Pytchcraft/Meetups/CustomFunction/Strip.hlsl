#ifndef STRIP_HLSLINCLUDE
#define STRIP_HLSLINCLUDE

void Strip_float(float Size, float Coord, out float Output)
{
    Output = 1 - step(Size / 2, abs(Coord));
}

#endif