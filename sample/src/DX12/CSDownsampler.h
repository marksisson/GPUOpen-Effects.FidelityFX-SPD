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
#pragma once

#include "Base/DynamicBufferRing.h"
#include "Base/Texture.h"

namespace CAULDRON_DX12
{
#define CS_MAX_MIP_LEVELS 12

    class CSDownsampler
    {
    public:
        void OnCreate(Device *pDevice, UploadHeap *pUploadHeap, ResourceViewHeaps *pResourceViewHeaps, DynamicBufferRing *pConstantBufferRing);
        void OnDestroy();

        void Draw(ID3D12GraphicsCommandList *pCommandList);
        Texture *GetTexture() { return &m_cubeTexture; }
        void GUI(int *pSlice);

        struct cbDownsample
        {
            uint32_t outWidth, outHeight;
            float invWidth, invHeight;
            uint32_t slice;
            uint32_t padding[3];
        };

    private:
        Device                       *m_pDevice = nullptr;

        Texture                       m_cubeTexture;

        struct Pass
        {
            CBV_SRV_UAV     m_constBuffer; // dimension
            CBV_SRV_UAV     m_UAV; //dest
            CBV_SRV_UAV     m_SRV; //src
        };

        Pass                          m_mip[CS_MAX_MIP_LEVELS];

        ResourceViewHeaps            *m_pResourceViewHeaps = nullptr;
        DynamicBufferRing            *m_pConstantBufferRing = nullptr;
        ID3D12RootSignature	         *m_pRootSignature = nullptr;
        ID3D12PipelineState	         *m_pPipeline = nullptr;

        SAMPLER                       m_sampler;

        CBV_SRV_UAV                   m_imGUISRV[CS_MAX_MIP_LEVELS * 6];
    };
}