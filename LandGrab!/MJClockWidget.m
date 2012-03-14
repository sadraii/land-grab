//
//  MJClockWidget.m
//  LandGrab!
//
//  Created by student on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJClockWidget.h"
#import "Graphics.h"

@implementation MJClockWidget

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
 
    NSInteger offset = 300;
    
    rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);     
    CGContextRef contextRef = UIGraphicsGetCurrentContext();            
    CGContextSetLineWidth(contextRef, 0.5);                  
    CGContextSetRGBFillColor(contextRef, 255, 255, 255, 1);             
    CGContextSetRGBStrokeColor(contextRef, 255, 255, 255, 1);            
    CGContextFillEllipseInRect(contextRef, rect);                 
    CGContextStrokeEllipseInRect(contextRef, rect);  
    
}


@end
