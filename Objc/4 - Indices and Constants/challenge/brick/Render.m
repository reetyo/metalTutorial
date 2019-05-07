//
//  Render.m
//  brick
//
//  Created by Cairo on 2019/5/7.
//  Copyright © 2019 Cairo. All rights reserved.
//

#import "Render.h"
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>


float vertices[12] = {
    -1,  1, 0,   // V0
    -1, -1, 0,   // V1
    1, -1, 0,   // V2
    1,  1, 0,   // V3
};

uint16_t indices[6] = {
    0,1,2,
    2,3,0
};

typedef struct _Constant{
    float animateBy;
}Constant;

Constant constant = {
    .animateBy = 0.0,
};

@interface Render()
@property (nonatomic,strong) id<MTLDevice> device;
@property (nonatomic,strong) id<MTLCommandQueue> commandQueue;

@property (nonatomic,strong) id<MTLRenderPipelineState> pipelineState;
@property (nonatomic,strong) id<MTLBuffer> vertexBuffer;
@property (nonatomic,strong) id<MTLBuffer> indexBuffer;

@property (nonatomic,assign) float time;

@end

@implementation Render

- (instancetype)initWithDevice:(id<MTLDevice>)device{
    if(self = [super init]){
        self.device = device;
        self.commandQueue = [device newCommandQueue];
        self.time = 0;
        [self buildModel];
        [self buildPipelineState];
    }
    return self;
}

- (void)buildModel{
    self.vertexBuffer = [self.device newBufferWithBytes:&vertices length:18 * sizeof(float) options:MTLResourceCPUCacheModeDefaultCache];
    self.indexBuffer = [self.device newBufferWithBytes:&indices length:6 * sizeof(uint32_t) options:MTLResourceCPUCacheModeDefaultCache];
}

- (void)buildPipelineState{
    id<MTLLibrary> library = [self.device newDefaultLibrary];
    id<MTLFunction> vertexFunction = [library newFunctionWithName:@"vertex_shader"];
    id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"fragment_shader"];
    
    MTLRenderPipelineDescriptor *pipelineDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
    pipelineDescriptor.vertexFunction = vertexFunction;
    pipelineDescriptor.fragmentFunction = fragmentFunction;
    pipelineDescriptor.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
    
    self.pipelineState = [self.device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:nil];
}

#pragma mark MTKViewDelegate

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size{

}

- (void)drawInMTKView:(MTKView *)view{
    id<CAMetalDrawable> drawable = view.currentDrawable;
    MTLRenderPassDescriptor* descriptor = view.currentRenderPassDescriptor;
    
    if(!drawable || !descriptor){
        return;
    }
    
    self.time += 1 / (float)view.preferredFramesPerSecond;
    float animatedBy = fabs(sin(self.time) / 2 + 0.5);
    constant.animateBy = animatedBy;
    
    
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    id<MTLRenderCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:descriptor];
    
    [commandEncoder setRenderPipelineState:self.pipelineState];
    [commandEncoder setVertexBuffer:self.vertexBuffer offset:0 atIndex:0];
    [commandEncoder setVertexBytes:&constant length:sizeof(constant) atIndex:1];
    [commandEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:6];
    [commandEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle indexCount:6 indexType:MTLIndexTypeUInt16 indexBuffer:self.indexBuffer indexBufferOffset:0];
    [commandEncoder endEncoding];
    [commandBuffer presentDrawable:drawable];
    [commandBuffer commit];
}

@end
