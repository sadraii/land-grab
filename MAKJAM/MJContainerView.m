//
//  MJContainerView.m
//  MAKJAM
//
//  Created by student on 2/16/12.
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
        // Initialization code
    }
    return self;
}


/*
 Draws the grid on the board
 */
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(ctx, 0, 20, 150, 1);
    CGContextSetLineWidth(ctx, 2);
    CGContextBeginPath(ctx);
    // Draw verticle lines
    for (int i=0; i<_board.boardSize.width*64;i+=64) {
        CGContextMoveToPoint(ctx, 0+i, 0);
        CGContextAddLineToPoint(ctx, 0+i, self.frame.size.height);
    }
    for (int i=0; i<_board.boardSize.height*64;i+=_board.tileSize) {
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
