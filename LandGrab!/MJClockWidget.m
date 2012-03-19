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

@synthesize clockTimer = _clockTimer;
@synthesize secondsLeft = _secondsLeft;

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        _secondsLeft = 300;
    }
    [self createTimer];
    return self;
}

- (void)createTimer {
    _clockTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    [_clockTimer fire];
}

- (void)updateTimer {
    
    if (_secondsLeft > 0) {
        //NSLog(@"Seconds Left: %i", _secondsLeft);
        _secondsLeft--;
        NSUInteger seconds = (_secondsLeft % 3600) % 60;
        
        [self setNeedsDisplay];
        
        //NSLog(@"Number of clockSeconds: %i", seconds);
        
        //Time is running out
        /*if (_secondsLeft <= 30) {
            
        }*/
    }
    else {
        [_clockTimer invalidate];
        [self endSequence];
    }
}

- (void) endSequence {
    NSLog(@"endSequence");
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    //NSLog(@"DrawRect is called.");
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
    NSUInteger seconds = (_secondsLeft % 3600) % 60;

    for (int x = _secondsLeft; x>0; x--) {  
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
