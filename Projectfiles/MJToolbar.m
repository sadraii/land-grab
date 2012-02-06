//
//  MJToolbar.m
//  MAKJAM
//
//  Created by Andrew Huss on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJToolbar.h"

@implementation MJToolbar

-(id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame]) == nil) {
		return self;
    }
    [self setBackgroundColor:[UIColor whiteColor]];
	[self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    return self;
}

- (void) setNeedsDisplay {
	[super setNeedsDisplay];
	
	NSLog(@"MJToolbar: %@", NSStringFromSelector(_cmd));
}

@end
