//
//  MJContainerView.m
//  LandGrab!
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJContainerView.h"
#import "MJBoard.h"

@implementation MJContainerView

@synthesize board = _board;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self setUserInteractionEnabled:YES];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
 // Drawing code
 [super drawRect:rect];
 CGContextRef ctx = UIGraphicsGetCurrentContext();
 CGContextSetRGBStrokeColor(ctx, 0, 20, 150, 1);
 CGContextSetLineWidth(ctx, 2);
 CGContextBeginPath(ctx);
 // Draw verticle lines
 for (int i=0; i<self.frame.size.width;i+=TILE_SIZE) {
 CGContextMoveToPoint(ctx, 0+i, 0);
 CGContextAddLineToPoint(ctx, 0+i, self.frame.size.height);
 }
 for (int i=0; i<self.frame.size.height;i+=TILE_SIZE) {
 CGContextMoveToPoint(ctx, 0, 0+i);
 CGContextAddLineToPoint(ctx, self.frame.size.width, 0+i);
 }
 // top left
 CGContextMoveToPoint(ctx, 0, 0);
 // top right
 CGContextAddLineToPoint(ctx, self.frame.size.width, 0);
 // bottom right
 CGContextAddLineToPoint(ctx, self.frame.size.width, self.frame.size.height);
 // bottom left
 CGContextAddLineToPoint(ctx, 0, self.frame.size.height);
 CGContextClosePath(ctx);
 CGContextStrokePath(ctx);
}


@end
