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
 
    // Draw outter circle
    rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);     
    CGContextRef contextRef = UIGraphicsGetCurrentContext();            
    CGContextSetLineWidth(contextRef, 0.5);                  
    CGContextSetRGBFillColor(contextRef, 255, 255, 255, 1);             
    CGContextSetRGBStrokeColor(contextRef, 0, 0, 0, 1);            
    CGContextFillEllipseInRect(contextRef, rect);                 
    CGContextStrokeEllipseInRect(contextRef, rect);  
    
    NSInteger offset = 5;
       
    // Draw inner circle
    rect = CGRectMake(0+(offset/2), 0+(offset/2), self.frame.size.width-offset, self.frame.size.height-offset);                 
    CGContextSetLineWidth(contextRef, 0.5);                  
    CGContextSetRGBFillColor(contextRef, 0, 0, 0, 0.5f);
    CGContextSetRGBStrokeColor(contextRef, 0.0, 0.0, 0.0, 0.5f);              
    
    CGContextFillEllipseInRect(contextRef, rect);                 
    CGContextStrokeEllipseInRect(contextRef, rect);     
    
    // Draw lines
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, (self.frame.size.width/2), (self.frame.size.height/2)); 
    for (int x=0; x<270; x++) {  
        
        CGContextSetLineWidth(context, 0.5);
        CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1);
        //CGContextMoveToPoint(context, (self.frame.size.width/2), (self.frame.size.height/2));   
        CGContextMoveToPoint(context, 0, 0);
        CGContextAddLineToPoint(context, ((self.frame.size.width/2)*(cos((x*1)*(M_PI/180)))), ((self.frame.size.height/2)*(sin((x*1)*(M_PI/180)))));                   
        CGContextStrokePath(context);                           
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);       
        CGContextFillPath(context);
    }    
}


@end
