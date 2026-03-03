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
cbuffer thumbnailCropBounds : register(b9)
{
    float4 uvScaleOffset;
};

void VS_ScreenSpace(uint vertexId : SV_VertexID, out float4 position : SV_POSITION, out float2 texCoord : TEXCOORD0)
{
    float2 baseUV;

    baseUV.x = (float)(vertexId & 1u);
    baseUV.y = (float)(1u - (vertexId >> 1u));

    position.xy = float2(baseUV.x * 2.0f - 1.0f, 1.0f - baseUV.y * 2.0f);
    position.zw = float2(1.0f, 1.0f);
    texCoord.xy = baseUV.xy * uvScaleOffset.zw + uvScaleOffset.xy;
}

void VS_ScreenClear(uint vertexId : SV_VertexID, out float4 position : SV_POSITION)
{
    float2 basePosition;

    basePosition.x = (float)((vertexId & 1u) * 2u) - 1.0f;
    basePosition.y = (float)(vertexId >> 1u) * 2.0f - 1.0f;

    position.xy = basePosition;
    position.zw = float2(1.0f, 1.0f);
}
