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
cbuffer tint : register(b0)
{
    float4 tintColour;
};
cbuffer fog : register(b1)
{
    float4 fogColour;
};
cbuffer alphaTest : register(b3)
{
    float4 alphaTestReference;
};

#ifdef FORCE_LOD
cbuffer forcedLOD : register(b5)
{
    float4 forcedLodLevel;
};
#endif

SamplerState diffuseSampler : register(s0);
Texture2D<float4> diffuseTexture : register(t0);

struct PS_INPUT
{
    float4 position : SV_POSITION;
    float4 vertexColour : COLOR0;
    linear centroid float4 texCoordFogFactorProjection : TEXCOORD0;
};

float4 main(PS_INPUT input) : SV_TARGET
{
    float4 sampledColour;
    float4 outputColour;

#ifdef TEXTURE_PROJECTION
    float2 projectedTextureUV = input.texCoordFogFactorProjection.xy / input.texCoordFogFactorProjection.ww;
    sampledColour.xyzw = diffuseTexture.Sample(diffuseSampler, projectedTextureUV).xyzw;
    sampledColour.xyzw = tintColour.xyzw * sampledColour.xyzw;
    sampledColour.w = input.vertexColour.w * sampledColour.w;
    if (sampledColour.w < alphaTestReference.w) discard;
    sampledColour.xyz = sampledColour.xyz * input.vertexColour.xyz + -fogColour.xyz;
    outputColour.xyz = input.texCoordFogFactorProjection.zzz * sampledColour.xyz + fogColour.xyz;
    outputColour.w = sampledColour.w;
    return outputColour;

#elif defined(FORCE_LOD)
    sampledColour.xyzw = diffuseTexture.SampleLevel(diffuseSampler, input.texCoordFogFactorProjection.xy, forcedLodLevel.x).xyzw;
    sampledColour.xyzw = tintColour.xyzw * sampledColour.xyzw;
    sampledColour.w = input.vertexColour.w * sampledColour.w;
    if (sampledColour.w < alphaTestReference.w) discard;
    sampledColour.xyz = sampledColour.xyz * input.vertexColour.xyz + -fogColour.xyz;
    outputColour.xyz = input.texCoordFogFactorProjection.zzz * sampledColour.xyz + fogColour.xyz;
    outputColour.w = sampledColour.w;
    return outputColour;

#else
    if (1 < input.texCoordFogFactorProjection.x)
        sampledColour.xyzw = diffuseTexture.SampleLevel(diffuseSampler, input.texCoordFogFactorProjection.xy, 0).xyzw;
    else
        sampledColour.xyzw = diffuseTexture.Sample(diffuseSampler, input.texCoordFogFactorProjection.xy).xyzw;
    sampledColour.xyzw = tintColour.xyzw * sampledColour.xyzw;
    sampledColour.w = input.vertexColour.w * sampledColour.w;
    if (sampledColour.w < alphaTestReference.w) discard;
    sampledColour.xyz = sampledColour.xyz * input.vertexColour.xyz + -fogColour.xyz;
    outputColour.xyz = input.texCoordFogFactorProjection.zzz * sampledColour.xyz + fogColour.xyz;
    outputColour.w = sampledColour.w;
    return outputColour;
#endif
}
