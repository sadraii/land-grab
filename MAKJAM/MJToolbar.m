//
//  MJToolbar.m
//  MAKJAM
//
//  Created by Andrew Huss on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJToolbar.h"
#import "MJPiece.h"
#import "MJViewController.h"
#import "MJPlayer.h"

@implementation MJToolbar

@synthesize parentViewController = _parentViewController;
//@synthesize toolbarHeight = _toolbarHeight;
@synthesize offset = _offset;
@synthesize pieces = _pieces;

/*
 Called by the storyboard
 Adds ourself as an observer to all New Game notifications and calls the method newGame on Notification post
 */
-(id) initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder]) == nil) {
		return self;
    }
	
    maxX = 0;
	_offset = 10;
	scale = 1;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newGame) name:@"NewGame" object:nil];
    return self;
}

/*
 The method called after receiving a New Game notification
 Calls the clear method
 */
- (void) newGame {
	NSLog(@"Toolbar: received new game notification");
//	[self setPieces:nil];
//	for (MJPiece* p in self.subviews) {
//		[self removePiece:p];
//	}
	[self clear];
}

/*
 Scales the piece to the size needed to fit in the toolbar
 First it needs to revert the piece to its original starting size
 The pieces height will be the height of the toolbar with an offset at the top and the bottom (specified in the iVar offset)
 */
//- (void) scalePiece:(MJPiece*)piece {
//	[piece revertToStartingSize];
//	pieceHeight = self.frame.size.height - (2.0f * _offset);
//
//	if (pieceHeight / piece.frame.size.height != scale) {
//		scale = pieceHeight / piece.frame.size.height;
//		piece.scale = scale;
//	}
//	[piece setFrame:CGRectMake(piece.frame.origin.x, 
//							   _offset, 
//							   piece.frame.size.width * scale, 
//							   pieceHeight)];
//}

/*
 Loops over all pieces after the index parameter and removes the piece then adds the piece back to the toolbar.
 This is needed after we remove or add a piece to the toolbar so that it can refresh itsself and shift the pieces accordingly.
 */
//- (void) reloadToolbarStartingAtIndex:(NSUInteger)index {
//	NSArray* tmp = nil;
//	
//	int length = _pieces.count - index;//min length is one
//	
//	tmp = [NSArray arrayWithArray:
//		   [_pieces objectsAtIndexes:
//			[NSIndexSet indexSetWithIndexesInRange:
//			 NSMakeRange(index, length)]]];//min array is the last object
//	[_pieces removeObjectsInArray:tmp];
//	
//	MJPiece* lastObj = _pieces.lastObject;
//	if (lastObj) {
//		maxX = lastObj.frame.origin.x + lastObj.frame.size.width;
//		[self setContentSize:CGSizeMake(maxX + _offset, self.frame.size.height)];
//	}
//	else {
//		maxX = 0;
//	}
//	for (MJPiece* p in tmp) {
//		[p removeFromSuperview];
//		[p setFrame:CGRectMake(maxX + _offset, 
//							   p.frame.origin.y, 
//							   p.frame.size.width, 
//							   p.frame.size.height)];
//		[p setCenter:CGPointMake(p.center.x, self.frame.size.height / 2)];
//		maxX += p.frame.size.width + _offset;
//		[self setContentSize:CGSizeMake(maxX + _offset, self.frame.size.height)];
//		[_pieces addObject:p];
//		[self addSubview:p];
//	}
//}

/*
 Calls the clear method
 Then adds all of the players pieces to the toolbar
 It only adds pieces that are not on the board.
 */
- (void) loadPlayersPieces:(MJPlayer*)player {
	for (MJPiece* p in player.pieces) {
		[self addPiece:p];
	}
}

/*
 All pieces in the toolbar call remove from superview
 Sets the pieces array to nil
 Ammounts to a blank toolbar
 */
- (void) clear {
	for (MJPiece* p in _pieces) {
		[p removeFromSuperview];
	}
	_pieces = nil;
}

#pragma mark - MJPieceDelegate Methods

/*
 Loops over the pieces in the pieces array and finds the location to add the new piece
 It finds the new location by looking at the inserting pieces center and finds the first piece that has a center greater than it.
 Calls reloadToolbarStartingAtIndex with the index we inserted the piece at.
 */
- (BOOL) addPiece:(MJPiece*)piece {
	if (piece.isPlayed) {
		return NO;
	}
	UIView* view = [[UIView alloc] initWithFrame:CGRectMake(offset, offset, piece.size.width, piece.size.height)];
	[piece setScale:piece.size.height / pieceHeight];
	[piece addAsSubviewToView:view];
	[self addSubview:view];
	NSLog(@"Toolbar subview count: %i", self.subviews.count);
	int index= 0;
	
	/*
	 Changing the if condition inside of the for loop to check instead of piece.center, to check piece.lastPosition(of the finger) then the piece would be inserted into the toolbar at the users finger instead of the piece center. You may need to make lastPosition a property in MJPiece.
	 */
	for (MJPiece* p in _pieces) {
		if (piece.origin.x <= p.origin.x) break;
		++index;
	}
	if (index >= (int)_pieces.count) {
		[_pieces addObject:piece];
		index = _pieces.count-1;
	}
	else {
		[_pieces insertObject:piece atIndex:index];
	}
	[self reloadToolbarStartingAtIndex:index];
	return YES;
//	if (_pieces == nil) {
//		_pieces = [[NSMutableArray alloc] init];
//	}
//	[self scalePiece:piece];
//	
//	int index= 0;
//	
//	/*
//	 Changing the if condition inside of the for loop to check instead of piece.center, to check piece.lastPosition(of the finger) then the piece would be inserted into the toolbar at the users finger instead of the piece center. You may need to make lastPosition a property in MJPiece.
//	 */
//	for (MJPiece* p in _pieces) {
//		if (piece.center.x <= p.center.x) break;
//		++index;
//	}
//	if (index >= (int)_pieces.count) {
//		[_pieces addObject:piece];
//		index = _pieces.count-1;
//	}
//	else {
//		[_pieces insertObject:piece atIndex:index];
//	}
//	[self reloadToolbarStartingAtIndex:index];
//	return YES;
}

/*
 Checks to see if the pieces array contains the piece we are trying to remove
 Stores the index of the piece we want to remove
 Removes the piece from the pieces array
 Reloads the toolbar starting at index of the removing piece.
 */
- (BOOL) removePiece:(MJPiece*)piece {
//	if (![_pieces containsObject:piece]) return NO;
	
//	int index = [_pieces indexOfObject:piece];
	[_pieces removeObject:piece];
//	[self reloadToolbarStartingAtIndex:index];
	return YES;
}

#pragma mark - UIScrollViewDelegate

/*
 Does not do anyting as of yet
 it is called when the user starts scrolling(left or right)
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//	NSLog(@"Will Begin Dragging");
}

@end
