//
//  MJTopBar.m
//  LandGrab!
//
//  Created by student on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJTopBar.h"
#import "Graphics.h"

@implementation MJTopBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // Colors
    CGColorRef redColor = [UIColor colorWithRed:1.0 green:0.0 
                                           blue:0.0 alpha:1.0].CGColor;
    CGColorRef blackColor = [UIColor blackColor].CGColor;
    CGColorRef blueColor = [UIColor blueColor].CGColor;
 //CGColorRef purpleColor = [UIColor colorWithRed:132.0 green:112.0 blue:255.0 alpha:1.0].CGColor; 99;184;255 
    CGColorRef purpleColor = [UIColor colorWithRed:0 green:255
                                              blue:255 alpha:1.0].CGColor; 
    CGColorRef lightGrayColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 
                                                 blue:230.0/255.0 alpha:1.0].CGColor;
    
    
    CGContextSetFillColorWithColor(ctx, blackColor);
    CGContextFillRect(ctx, self.bounds);
    CGContextSetLineWidth(ctx, 2);
    CGContextBeginPath(ctx);
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
    
   
    

    
    NSInteger offset = 2;
    CGRect paperRect = CGRectMake(offset, offset, self.frame.size.width-offset, self.frame.size.height-offset); 
    
    drawLinearGradient(ctx, CGRectInset(paperRect, 5.0, 5.0), purpleColor, blackColor);
    
    CGRect strokeRect = CGRectInset(paperRect, 5.0, 5.0);
    CGContextSetStrokeColorWithColor(ctx, blackColor);
    CGContextSetLineWidth(ctx, 1.0);
    CGContextStrokeRect(ctx, strokeRect);
}
*/

@end
