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
    unitLength = 64;
    return self;
}

#pragma mark - Board methods
-(CGPoint) snapPieceToPoint:(MJPiece*)piece {
	int offX = (NSUInteger)piece.frame.origin.x % unitLength;
	int offY = (NSUInteger)piece.frame.origin.y % unitLength;
	NSLog(@"Off X: %f", offX / (float)unitLength);
	NSLog(@"Off Y: %f", offY / (float)unitLength);
	
	CGPoint newCenter = piece.center;
	if ((offX / (float)unitLength) >= 0.5f) {
		newCenter.x += offX;
	}
	else {
		newCenter.x -= offX;
	}
	if ((offY / (float)unitLength) >= 0.5f) {
		newCenter.y += offY;
	}
	else {
		newCenter.y -= offY;
	}
	return newCenter;
}


#pragma mark - MJPieceDelegate Methods
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
	[piece setCenter:[self snapPieceToPoint:piece]];
	NSLog(@" Snap to board at: (%f, %f)", piece.center.x, piece.center.y);
	return YES;
}

- (BOOL) removePiece:(MJPiece *)piece {
	return NO;
}

@end