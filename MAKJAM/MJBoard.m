//
//  MJBoard.m
//  MAKJAM
//
//  Created by Andrew Huss on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "MJBoard.h"

@implementation MJBoard

-(id) initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder]) == nil) {
		return self;
    }
    
    return self;
}

- (BOOL) addPiece:(MJPiece *)piece {
	//[piece setCenter:CGPointMake(piece.center.x + piece.superview.frame.origin.x, piece.center.y + (self.view.frame.size.height - (self.view.frame.size.height - piece.superview.frame.origin.y)))];
	if ([self isEqual:piece.superview]) {
		[piece setCenter:CGPointMake(piece.center.x + self.frame.origin.x, piece.center.y + self.frame.origin.y)];
		[self addSubview:piece];
	}
	else {
		[piece setCenter:CGPointMake(piece.center.x - self.frame.origin.x, piece.center.y - (piece.superview.frame.size.height - (piece.superview.frame.size.height - self.frame.origin.y)))];
		[self addSubview:piece];
	}
	NSLog(@"Added to board at: (%f, %f)", piece.center.x, piece.center.y);
	return YES;
}

- (BOOL) removePiece:(MJPiece *)piece {
	return NO;
}

@end