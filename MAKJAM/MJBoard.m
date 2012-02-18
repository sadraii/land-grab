//
//  MJBoard.m
//  MAKJAM
//
//  Created by Andrew Huss on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "MJBoard.h"
#import "MJPlayer.h"

@implementation MJBoard

@synthesize pieces = _pieces;
@synthesize boardSize = _boardSize;
@synthesize containerView = _containerView;
@synthesize tileSize;

-(id) initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder]) == nil) {
		return self;
    }
	_boardSize = CGSizeMake(30, 30);
    tileSize = 64;
	[super setDelegate:self];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newGame) name:@"NewGame" object:nil];
    return self;
}

#pragma mark - Board methods
- (void) newGame {
	NSLog(@"Board: received new game notification");
//	_pieces = [[NSMutableArray alloc] init];
//	[_containerView removeFromSuperview];
	[self setContainerView:nil];
	_containerView = [[MJContainerView alloc] init];
    [_containerView setBoard:self];
	[_containerView setBackgroundColor:[UIColor darkGrayColor]];
	[self addSubview:_containerView];
	[self setBoardSize:_boardSize];
}


- (void) setBoardSize:(CGSize)size {
	if(!CGSizeEqualToSize(CGSizeZero, size)) _boardSize = size;
	NSLog(@"Setting board size: (%f X %f)", _boardSize.width, _boardSize.height);
	
	[self setContentSize:CGSizeMake((_boardSize.width * tileSize), (_boardSize.height * tileSize))];
	[_containerView setFrame:CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)];
	[self setMinimumZoomScale:(self.frame.size.width / _containerView.frame.size.width-50)];
}

- (void) scalePiece:(MJPiece*)piece {
	CGPoint originalCenter = piece.center;
	[piece revertToStartingSize];
//	[piece setFrame:CGRectMake(piece.frame.origin.x, piece.frame.origin.y, piece.startingSize.width * self.zoomScale, piece.startingSize.height * self.zoomScale)];
//	[piece setFrame:CGRectMake(originalCenter.x, originalCenter.y, piece.frame.size.width * self.zoomScale, piece.frame.size.height * self.zoomScale)];
	[piece setFrame:CGRectMake(originalCenter.x, originalCenter.y, piece.frame.size.width * self.zoomScale, piece.frame.size.height * self.zoomScale)];
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
	
	int offX = ((NSUInteger)piece.frame.origin.x % tileSize);
	int offY = ((NSUInteger)piece.frame.origin.y % tileSize);
//	NSLog(@"Off X&Y: (%i, %i)", offX, offY);
	
	CGPoint newCenter = piece.center;
	
	if ((offX / (float)tileSize) > 0.5f) 
		newCenter.x += (tileSize - offX);
	else 
		newCenter.x -= offX;
	
	if ((offY / (float)tileSize) > 0.5f) 
		newCenter.y += (tileSize - offY);
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

- (CGPoint) originOfPiece:(MJPiece*)piece {
	CGPoint origin = piece.frame.origin;
	origin.x /= tileSize;
	origin.y /= tileSize;
	NSLog(@"Piece Coordinates: (%i, %i)", (int)origin.x, (int)origin.y);
	return origin;
}


#pragma mark - MJPieceDelegate Methods
- (BOOL) addPiece:(MJPiece *)piece {
	[piece setPlayed:YES];
	[piece setCenter:[self snapPieceToPoint:piece]];
	[_containerView addSubview:piece];
	[_pieces addObject:piece];
	[self originOfPiece:piece];
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
//	NSLog(@"Zoom scale: %f", scale);
//	NSLog(@"Scroll View: %f X %f", scrollView.contentSize.width, scrollView.contentSize.height);
	CGSize contentSize = CGSizeMake(roundf(scrollView.contentSize.width), roundf(scrollView.contentSize.width));
	
	int offW = (int)contentSize.width % tileSize;
	int offH = (int)contentSize.height % tileSize;
	while (offW != 0 || offH != 0) {
		if (offW / (float)tileSize > 0.5f) {
			contentSize.width += (tileSize - offW);
			contentSize.height += (tileSize - offW);
			offW = (int)contentSize.width % tileSize;
			offH = (int)contentSize.height % tileSize;
		}
		else {
			contentSize.width -= offW;
			contentSize.height -= offW;
			offW = (int)contentSize.width % tileSize;
			offH = (int)contentSize.height % tileSize;
		}
		
		if (offH / (float)tileSize > 0.5f) {
			contentSize.height += (tileSize - offH);
			contentSize.width += (tileSize - offH);
			offW = (int)contentSize.width % tileSize;
			offH = (int)contentSize.height % tileSize;
		}
		else {
			contentSize.height -= offH;
			contentSize.width -= offH;
			offW = (int)contentSize.width % tileSize;
			offH = (int)contentSize.height % tileSize;
		}
	}
	[scrollView setZoomScale:contentSize.width / (scrollView.contentSize.width / scale) animated:YES];
	[scrollView setContentSize:contentSize];
}


@end