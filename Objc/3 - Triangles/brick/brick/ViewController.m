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
#import "Render.h"

@interface ViewController ()

@property (nonatomic,strong) MTKView* metalView;
@property (nonatomic,strong) id<MTLDevice> device;
@property (nonatomic,strong) id<MTLCommandQueue> commandQueue;
@property (nonatomic,strong) Render* renderer;

@end

@implementation ViewController

- (MTKView*)metalView{
    return (MTKView*)self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.metalView.device = MTLCreateSystemDefaultDevice();
    
    self.metalView.clearColor = MTLClearColorMake(0.0, 0.4,0.21 , 1.0);
    self.renderer = [[Render alloc] initWithDevice:self.metalView.device];
    self.metalView.delegate = self.renderer;
}


@end
