//
//  MJBoard.m
//  MAKJAM
//
//  Created by Andrew Huss on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJPiece.h"
#import "MJContainerView.h"
#import "MJBoard.h"
#import "MJPlayer.h"

@implementation MJBoard

@synthesize pieces = _pieces;
@synthesize boardSize = _boardSize;
@synthesize containerView = _containerView;
@synthesize tileSize;

#pragma mark - Board methods
/*
 The board size is set
 We specify what tile size we have used to design the tiles (default 64px)
 Add ourself as an observer to the NewGame notification, and will call the newGame method on any posts of this notificaiton.
 */
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

/*
 Sets the container view to nil
 Sets up the container view
 Set the board size.
 */
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

/*
 Sets the board size reletative to the tile size.
 You should pass this a cgsize with the number of tiles for width and height instead of number of points.
 */
- (void) setBoardSize:(CGSize)size {
	if(!CGSizeEqualToSize(CGSizeZero, size)) _boardSize = size;
	NSLog(@"Setting board size: (%f X %f)", _boardSize.width, _boardSize.height);
	
	[self setContentSize:CGSizeMake((_boardSize.width * tileSize), (_boardSize.height * tileSize))];
	[_containerView setFrame:CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)];
	[self setMinimumZoomScale:(self.frame.size.width / _containerView.frame.size.width-50)];
}

/*
 Scales the piece back the original starting size
 then scales it down to the current board zoom scale
 
 THIS IS NOT USED TO ADD PIECE TO THE BOARD
 PIECES MUST BE THE ORIGINAL STARTING SIZE WHEN ADDING TO THE BOARD.
 
 Pieces center stays the same as the starting parameter piece
 */
- (void) scalePiece:(MJPiece*)piece {
//	CGPoint originalCenter = piece.center;
//	[piece revertToStartingSize];
//	[piece setFrame:CGRectMake(originalCenter.x, originalCenter.y, piece.frame.size.width * self.zoomScale, piece.frame.size.height * self.zoomScale)];
//	[piece setCenter:originalCenter];
	piece.scale = self.zoomScale;

	CGPoint startingOrigin = piece.origin;
	[piece setScale:self.zoomScale];
	
}

/*
 Finds the closest tile origin to the origin of the piece.
 Can be:
 Top Left
 Top Right
 Bottom Left
 Bottom Right
 */
//-(CGPoint) snapPieceToPoint:(MJPiece*)piece {
//	[piece snapToPoint];
//	return CGPointZero;//FIX
//	[piece revertToStartingSize];
//	/*
//	 The problem causing the whitespace was a small fraction added on to the pieces origin.
//	 By rounding the origin to a whole number it fixes the whitespace problem.
//	 YAY!!!!
//	 */
//	[piece setFrame:CGRectMake(roundf(piece.frame.origin.x), roundf(piece.frame.origin.y), piece.frame.size.width, piece.frame.size.height)];
//	
//	int offX = ((NSUInteger)piece.frame.origin.x % tileSize);
//	int offY = ((NSUInteger)piece.frame.origin.y % tileSize);
////	NSLog(@"Off X&Y: (%i, %i)", offX, offY);
//	
//	CGPoint newCenter = piece.center;
//	
//	if ((offX / (float)tileSize) > 0.5f) 
//		newCenter.x += (tileSize - offX);
//	else 
//		newCenter.x -= offX;
//	
//	if ((offY / (float)tileSize) > 0.5f) 
//		newCenter.y += (tileSize - offY);
//	else 
//		newCenter.y -= offY;
//	
//	
//	
//	if (newCenter.x - (piece.frame.size.width / 2) < 0) {
//		newCenter.x = piece.frame.size.width / 2;
//	}
//	else if (newCenter.x + (piece.frame.size.width / 2) > _containerView.bounds.size.width) {
//		newCenter.x = _containerView.bounds.size.width - (piece.frame.size.width / 2);
//	}
//	
//	if (newCenter.y - (piece.frame.size.height / 2) < 0) {
//		newCenter.y = piece.frame.size.height / 2;
//	}
//	else if (newCenter.y + (piece.frame.size.width / 2) > _containerView.bounds.size.height) {
//		newCenter.y = _containerView.bounds.size.height - (piece.frame.size.height / 2);
//	}
//	
//	return newCenter;
//}


/*
 Returns a coordinate that is relative to our tile size.
 E.G. a piece has an origin at point (64,64) it will be at coordinate (1,1).
 */
- (CGPoint) originOfPiece:(MJPiece*)piece {
	CGPoint origin = piece.origin;
	origin.x /= tileSize;
	origin.y /= tileSize;
	NSLog(@"Piece Coordinates: (%i, %i)", (int)origin.x, (int)origin.y);
	return origin;
}


#pragma mark - MJPieceDelegate Methods

/*
 Sets the pieces played flag to YES
 snaps piece to point
 Adds piece to the containerview
 Finds the origin of the piece relative to tile size
 */
- (BOOL) addPiece:(MJPiece *)piece {
	[piece revertToStartingSize];
	[piece setIsPlayed:YES];
	[piece snapToPoint];
	[piece addAsSubviewToView:_containerView];
//	[piece setCenter:[self snapPieceToPoint:piece]];
//	[_containerView addSubview:piece];
	[_pieces addObject:piece];
	[self originOfPiece:piece];
	return YES;
}

/*
 Removes the piece from the pieces array.
 */
- (BOOL) removePiece:(MJPiece *)piece {
	if (![_pieces containsObject:piece]) return NO;
	[_pieces removeObject:piece];
	return YES;
}

#pragma mark - UISCrollViewDelegate Methods

/*
 Sets the containerview as the view we want to be zoomable
 */
- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return _containerView;
}

/*
 Attempts to round the zoom scale to a scale that will work nicley with the tile size
 If it does not work nicley it will mess up the snap the piece method.
 Still needs some fine tuning
 */
- (void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {

//	CGSize contentSize = CGSizeMake(roundf(scrollView.contentSize.width), roundf(scrollView.contentSize.width));
//	
//	int offW = (int)contentSize.width % tileSize;
//	int offH = (int)contentSize.height % tileSize;
//	while (offW != 0 || offH != 0) {
//		if (offW / (float)tileSize > 0.5f) {
//			contentSize.width += (tileSize - offW);
//			contentSize.height += (tileSize - offW);
//			offW = (int)contentSize.width % tileSize;
//			offH = (int)contentSize.height % tileSize;
//		}
//		else {
//			contentSize.width -= offW;
//			contentSize.height -= offW;
//			offW = (int)contentSize.width % tileSize;
//			offH = (int)contentSize.height % tileSize;
//		}
//		
//		if (offH / (float)tileSize > 0.5f) {
//			contentSize.height += (tileSize - offH);
//			contentSize.width += (tileSize - offH);
//			offW = (int)contentSize.width % tileSize;
//			offH = (int)contentSize.height % tileSize;
//		}
//		else {
//			contentSize.height -= offH;
//			contentSize.width -= offH;
//			offW = (int)contentSize.width % tileSize;
//			offH = (int)contentSize.height % tileSize;
//		}
//	}
//	[scrollView setZoomScale:contentSize.width / (scrollView.contentSize.width / scale) animated:YES];
//	[scrollView setContentSize:contentSize];
}


@end