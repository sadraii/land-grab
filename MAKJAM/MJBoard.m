//
//  MJBoard.m
//  MAKJAM
//
//  Created by Andrew Huss on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "MJBoard.h"

@implementation MJBoard

@synthesize pieces = _pieces;
@synthesize containerView = _containerView;

-(id) initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder]) == nil) {
		return self;
    }
    unitLength = 64;
    return self;
}

#pragma mark - Board methods
- (void) clearBoard {
	_pieces = [[NSMutableArray alloc] init];
	
	[_containerView removeFromSuperview];
	_containerView = [[UIView alloc] init];
	for (MJPiece* p in self.subviews) {
		[p removeFromSuperview];
	}
	[self addSubview:_containerView];
}

- (void) setBoardSize:(CGSize)size {
	[self setContentSize:CGSizeMake((int)(size.width * unitLength), (int)(size.width * unitLength))];
	[_containerView setFrame:CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)];
}

-(CGPoint) snapPieceToPoint:(MJPiece*)piece {
	/*
	 The problem causing the whitespace was a small fraction added on to the pieces origin.
	 By rounding the origin to a whole number it fixes the whitespace problem.
	 YAY!!!!
	 */
	[piece setFrame:CGRectMake(roundf(piece.frame.origin.x), roundf(piece.frame.origin.y), piece.frame.size.width, piece.frame.size.height)];
	
	int offX = ((NSUInteger)piece.frame.origin.x % unitLength);
	int offY = ((NSUInteger)piece.frame.origin.y % unitLength);
	
	CGPoint newCenter = piece.center;
	
	if ((offX / (float)unitLength) > 0.5f) 
		newCenter.x += (unitLength - offX);
	else 
		newCenter.x -= offX;
	
	
	if ((offY / (float)unitLength) > 0.5f) 
		newCenter.y += (unitLength - offY);
	else 
		newCenter.y -= offY;
	return newCenter;
}


#pragma mark - MJPieceDelegate Methods
- (BOOL) addPiece:(MJPiece *)piece {
	[_containerView addSubview:piece];
	[piece setCenter:[self snapPieceToPoint:piece]];
	[_pieces addObject:piece];
	return YES;
}

- (BOOL) removePiece:(MJPiece *)piece {
	if (![_pieces containsObject:piece]) return NO;
	
	int index = [_pieces indexOfObject:piece];
	NSLog(@"Removing board piece at index: %i", index);
	[_pieces removeObject:piece];
	
	return YES;
}

@end