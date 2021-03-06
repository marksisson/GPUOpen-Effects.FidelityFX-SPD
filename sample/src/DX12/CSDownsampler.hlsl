// SPDSample
//
// Copyright (c) 2020 Advanced Micro Devices, Inc. All rights reserved.
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

//--------------------------------------------------------------------------------------
// Constant Buffer
//--------------------------------------------------------------------------------------
cbuffer cbPerFrame : register(b0)
{
    uint2  u_outSize;
    float2 u_invSize;
    uint   u_slice;
}

//--------------------------------------------------------------------------------------
// Texture definitions
//--------------------------------------------------------------------------------------
RWTexture2DArray<float4>         outputTex           : register(u0);
Texture2DArray                   inputTex            : register(t0);
SamplerState                     samLinear     : register(s0);

// Main function
//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
[numthreads(8, 8, 1)]
void main(uint3 LocalThreadId : SV_GroupThreadID, uint3 WorkGroupId : SV_GroupID, uint3 DispatchId : SV_DispatchThreadID)
{
    if (DispatchId.x >= u_outSize.x || DispatchId.y >= u_outSize.y)
        return;

    float2 samplerTexCoord = u_invSize * float2(DispatchId.xy) * 2.0 + u_invSize;
    float4 result = inputTex.SampleLevel(samLinear, float3(samplerTexCoord, u_slice), 0);
    result.r = max(min(result.r * (12.92), (0.0031308)), (1.055) * pow(result.r, (0.41666)) - (0.055));
    result.g = max(min(result.g * (12.92), (0.0031308)), (1.055) * pow(result.g, (0.41666)) - (0.055));
    result.b = max(min(result.b * (12.92), (0.0031308)), (1.055) * pow(result.b, (0.41666)) - (0.055));

    outputTex[int3(DispatchId.xy, u_slice)] = result;
}