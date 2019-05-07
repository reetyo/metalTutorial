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


float vertices[9] = {
    0, 1, 0,
   -1,-1, 0,
    1,-1, 0
};

@interface Render()
@property (nonatomic,strong) id<MTLDevice> device;
@property (nonatomic,strong) id<MTLCommandQueue> commandQueue;

@property (nonatomic,strong) id<MTLRenderPipelineState> pipelineState;
@property (nonatomic,strong) id<MTLBuffer> vertexBuffer;

@end

@implementation Render

- (instancetype)initWithDevice:(id<MTLDevice>)device{
    if(self = [super init]){
        self.device = device;
        self.commandQueue = [device newCommandQueue];
        [self buildModel];
        [self buildPipelineState];
    }
    return self;
}

- (void)buildModel{
    self.vertexBuffer = [self.device newBufferWithBytes:&vertices length:9 * sizeof(float) options:MTLResourceCPUCacheModeDefaultCache];
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
    
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    id<MTLRenderCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:descriptor];
    
    [commandEncoder setRenderPipelineState:self.pipelineState];
    [commandEncoder setVertexBuffer:self.vertexBuffer offset:0 atIndex:0];
    [commandEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:3];
    [commandEncoder endEncoding];
    [commandBuffer presentDrawable:drawable];
    [commandBuffer commit];
}

@end
