//
//  Render.h
//  brick
//
//  Created by Cairo on 2019/5/7.
//  Copyright © 2019 Cairo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MetalKit/MetalKit.h>
#import <Metal/Metal.h>

@interface Render : NSObject<MTKViewDelegate>

- (instancetype)initWithDevice:(id<MTLDevice>)device;

@end
