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
- (void) clearBoard {
	for (MJPiece* p in self.subviews) {
		[p removeFromSuperview];
	}
}

-(CGPoint) snapPieceToPoint:(MJPiece*)piece {
	/*
	 I added one to offX and offY because the coordinate system starts at 0
	 i beleive that this fixes the problem where their is a whitespace between the snapped pieces.
	 */
	int offX = ((NSUInteger)piece.frame.origin.x % unitLength) + 1;
	int offY = ((NSUInteger)piece.frame.origin.y % unitLength) + 1;
	
	CGPoint newCenter = piece.center;
	if ((offX / (float)unitLength) > 0.5f) {
		newCenter.x += (unitLength - offX);
	}
	else {
		newCenter.x -= offX;
	}
	if ((offY / (float)unitLength) > 0.5f) {
		newCenter.y += (unitLength - offY);
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
	NSLog(@" Snap to board at: (%f, %f)", piece.frame.origin.x, piece.frame.origin.y);
	return YES;
}

- (BOOL) removePiece:(MJPiece *)piece {
	return NO;
}

@end