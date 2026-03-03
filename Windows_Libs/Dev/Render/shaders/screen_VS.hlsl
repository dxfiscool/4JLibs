/*
MIT License

Copyright (c) 2026 Patoke

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
cbuffer screenspace_constants : register(b9)
{
    float4 v_scaleoffset;
};

void VS_ScreenSpace(uint v0 : SV_VertexID, out float4 o0 : SV_POSITION, out float2 o1 : TEXCOORD0)
{
    float4 r0, r1;

    o0.zw = float2(1, 1);
    r0.xy = (int2)v0.xx & int2(1, -2);
    r0.z = (uint)r0.x << 1;
    r0.yz = (int2)r0.yz + int2(-1, -1);
    r1.x = (int)r0.x;
    o0.xy = (int2)r0.zy;
    r0.x = (uint)v0.x >> 1;
    r0.x = (int)-r0.x + 1;
    r1.y = (int)r0.x;
    o1.xy = r1.xy * v_scaleoffset.zw + v_scaleoffset.xy;
}

void VS_ScreenClear(uint v0 : SV_VertexID, out float4 o0 : SV_POSITION)
{
    float4 r0;

    r0.x = (uint)v0.x << 1;
    r0.x = (int)r0.x & 2;
    r0.x = (int)r0.x + -1;
    o0.x = (int)r0.x;
    r0.x = (int)v0.x & -2;
    r0.x = (int)r0.x + -1;
    o0.y = (int)r0.x;
    o0.zw = float2(1, 1);
}