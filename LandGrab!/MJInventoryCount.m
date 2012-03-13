//
//  MJInventoryCount.m
//  LandGrab!
//
//  Created by Helen Saenz on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJInventoryCount.h"

@implementation MJInventoryCount

@synthesize counter = _counter;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        UILabel *tmpCounter = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _counter = tmpCounter;
        _counter.textColor = [UIColor whiteColor];
        _counter.text = @"1";
        [_counter setFont:[UIFont systemFontOfSize:20]];
        [_counter setCenter:self.center];
        [_counter setTextAlignment:UITextAlignmentCenter];
        [_counter setBackgroundColor:[UIColor clearColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCounterWith:) name:@"updateCounterWith:" object:nil];
        [self addSubview:_counter];
    }
    return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, rect);
    CGContextSetFillColor(ctx, CGColorGetComponents([[UIColor redColor] CGColor]));
    CGContextFillPath(ctx);
    
}


@end
