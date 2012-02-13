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
	[super setDelegate:self];
    return self;
}

#pragma mark - Board methods
- (void) clearBoard {
	_pieces = [[NSMutableArray alloc] init];
	
	[_containerView removeFromSuperview];
	_containerView = [[UIView alloc] init];
	[_containerView setBackgroundColor:[UIColor whiteColor]];
	
	for (MJPiece* p in self.subviews) {
		[p removeFromSuperview];
	}
	[self addSubview:_containerView];
}

- (void) setBoardSize:(CGSize)size {
	[self setContentSize:CGSizeMake((int)(size.width * unitLength), (int)(size.width * unitLength))];
	[_containerView setFrame:CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)];
	[self setMinimumZoomScale:(self.frame.size.width / _containerView.frame.size.width)];
}

- (void) scalePiece:(MJPiece*)piece {
	CGPoint originalCenter = piece.center;
	[piece revertToStartingSize];
//	[piece setFrame:CGRectMake(piece.frame.origin.x, piece.frame.origin.y, piece.startingSize.width * self.zoomScale, piece.startingSize.height * self.zoomScale)];
	[piece setFrame:CGRectMake(originalCenter.x, originalCenter.y, piece.startingSize.width * self.zoomScale, piece.startingSize.height * self.zoomScale)];
	[piece setCenter:originalCenter];
	piece.scale = self.zoomScale;
}

-(CGPoint) snapPieceToPoint:(MJPiece*)piece {
	[piece revertToStartingSize];
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
	
	
	
	if (newCenter.x - (piece.frame.size.width / 2) < 0) {
		newCenter.x = piece.frame.size.width / 2;
	}
	else if (newCenter.x + (piece.frame.size.width / 2) > _containerView.bounds.size.width) {
		newCenter.x = _containerView.bounds.size.width - (piece.frame.size.width / 2);
	}
	
	if (newCenter.y - (piece.frame.size.height / 2) < 0) {
		newCenter.y = piece.frame.size.height / 2;
	}
	else if (newCenter.y + (piece.frame.size.width / 2) > _containerView.bounds.size.height) {
		newCenter.y = _containerView.bounds.size.height - (piece.frame.size.height / 2);
	}
	
	return newCenter;
}


#pragma mark - MJPieceDelegate Methods
- (BOOL) addPiece:(MJPiece *)piece {
	[piece setCenter:[self snapPieceToPoint:piece]];
	[_containerView addSubview:piece];
	[_pieces addObject:piece];
	return YES;
}

- (BOOL) removePiece:(MJPiece *)piece {
	if (![_pieces containsObject:piece]) return NO;
	
//	int index = [_pieces indexOfObject:piece];
//	NSLog(@"Removing board piece at index: %i", index);
	[_pieces removeObject:piece];
	
	return YES;
}

#pragma mark - UISCrollViewDelegate Methods

- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return _containerView;
}

- (void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
	NSLog(@"Zoom scale: %f", scale);
}

@end