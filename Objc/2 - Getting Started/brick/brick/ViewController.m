//
//  ViewController.m
//  brick
//
//  Created by Cairo on 2019/5/6.
//  Copyright © 2019 Cairo. All rights reserved.
//

#import "ViewController.h"
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

@interface ViewController () <MTKViewDelegate>

@property (nonatomic,strong) MTKView* metalView;
@property (nonatomic,strong) id<MTLDevice> device;
@property (nonatomic,strong) id<MTLCommandQueue> commandQueue;

@end

@implementation ViewController

- (MTKView*)metalView{
    return (MTKView*)self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.metalView.device = MTLCreateSystemDefaultDevice();
    self.device = self.metalView.device;
    
    self.metalView.clearColor = MTLClearColorMake(0.0, 0.4,0.21 , 1.0);
    self.metalView.delegate = self;
    self.commandQueue = [self.device newCommandQueue];
}

#pragma mark MTKViewDelegate

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    
}

- (void)drawInMTKView:(MTKView *)view {
    id<CAMetalDrawable> drawable = view.currentDrawable;
    MTLRenderPassDescriptor* descriptor = view.currentRenderPassDescriptor;
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    id<MTLCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:descriptor];
    
    [commandEncoder endEncoding];
    [commandBuffer presentDrawable:drawable];
    [commandBuffer commit];
    
}

@end
