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

//-(id) initWithFrame:(CGRect)frame {
//    if ((self = [super initWithFrame:frame]) == nil) {
//		return self;
//    }
//	
//	maxX = 0;
//	_offset = 20;
//	_pieces = [[NSMutableArray alloc] init];
//    return self;
//}

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

//- (void) setToolbarHeight:(CGFloat)toolbarHeight {
//	NSLog(@"Chaning toolbar height");
//	CGRect frame = self.frame;
//	if (frame.origin.y) {
//		frame.origin.y += (_toolbarHeight - toolbarHeight);
//	}
//	_toolbarHeight = toolbarHeight;
//	frame.size.height = _toolbarHeight;
//}

- (void) newGame {
	NSLog(@"Toolbar: received new game notification");
	[self setPieces:nil];
	for (MJPiece* p in self.subviews) {
		[self removePiece:p];
//		[p removeFromSuperview];
	}
//	[self reloadToolbarStartingAtIndex:0];
}

- (void) scalePiece:(MJPiece*)piece {
	pieceHeight = self.frame.size.height - (2.0f * _offset);

	if (pieceHeight / piece.frame.size.height != scale) {
		scale = pieceHeight / piece.frame.size.height;
		piece.scale = scale;
	}
	[piece setFrame:CGRectMake(piece.frame.origin.x, 
							   _offset, 
							   piece.frame.size.width * scale, 
							   pieceHeight)];
}

- (void) reloadToolbarStartingAtIndex:(NSUInteger)index {
	NSArray* tmp = nil;
	
	int length = _pieces.count - index;//min length is one
	
	tmp = [NSArray arrayWithArray:
		   [_pieces objectsAtIndexes:
			[NSIndexSet indexSetWithIndexesInRange:
			 NSMakeRange(index, length)]]];//min array is the last object
	[_pieces removeObjectsInArray:tmp];
	
	MJPiece* lastObj = _pieces.lastObject;
	if (lastObj) {
		maxX = lastObj.frame.origin.x + lastObj.frame.size.width;
		[self setContentSize:CGSizeMake(maxX + _offset, self.frame.size.height)];
	}
	else {
		maxX = 0;
	}
	for (MJPiece* p in tmp) {
		[p removeFromSuperview];
		[p setFrame:CGRectMake(maxX + _offset, 
							   p.frame.origin.y, 
							   p.frame.size.width, 
							   p.frame.size.height)];
		[p setCenter:CGPointMake(p.center.x, self.frame.size.height / 2)];
		maxX += p.frame.size.width + _offset;
		[self setContentSize:CGSizeMake(maxX + _offset, self.frame.size.height)];
		[_pieces addObject:p];
		[self addSubview:p];
	}
}


- (void) loadPlayersPieces:(MJPlayer*)player {
	[self clear];
	for (MJPiece* p in player.pieces) {
		if (!p.played) {
			[self addPiece:p];
		}
	}
}

- (void) clear {
	for (MJPiece* p in _pieces) {
		[p removeFromSuperview];
	}
	_pieces = nil;
}

#pragma mark - MJPieceDelegate Methods

- (BOOL) addPiece:(MJPiece*)piece {
	if (_pieces == nil) {
		_pieces = [[NSMutableArray alloc] init];
	}
	
	[piece revertToStartingSize];
	[self scalePiece:piece];
	
	int index= 0;
	
	/*
	 Changing the if condition inside of the for loop to check instead of piece.center, to check piece.lastPosition(of the finger) then the piece would be inserted into the toolbar at the users finger instead of the piece center. You may need to make lastPosition a property in MJPiece.
	 */
	for (MJPiece* p in _pieces) {
		if (piece.center.x <= p.center.x) break;
		++index;
	}
	if (index >= (int)_pieces.count) {
		[_pieces addObject:piece];
//		NSLog(@"Added Piece at end: %i", [_pieces indexOfObject:piece]);
		index = _pieces.count-1;
		//		[self addSubview:piece];
	}
	else {
//		NSLog(@"Inserting Piece at index: %i of %i", index, _pieces.count);
		[_pieces insertObject:piece atIndex:index];
	}
	[self reloadToolbarStartingAtIndex:index];
	return YES;
}

- (BOOL) removePiece:(MJPiece*)piece {
	if (![_pieces containsObject:piece]) return NO;
	
	int index = [_pieces indexOfObject:piece];
	[_pieces removeObject:piece];
	
	[self reloadToolbarStartingAtIndex:index];
	return YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//	NSLog(@"Will Begin Dragging");
}

@end
