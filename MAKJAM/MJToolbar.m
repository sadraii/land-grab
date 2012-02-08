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

@implementation MJToolbar

@synthesize parentViewController = _parentViewController;
@synthesize toolbarHeight = _toolbarHeight;
@synthesize pieces = _pieces;

//-(id) initWithFrame:(CGRect)frame {
//    if ((self = [super initWithFrame:frame]) == nil) {
//		return self;
//    }
//	
//	maxX = 0;
//	offset = 20;
//	_pieces = [[NSMutableArray alloc] init];
//    return self;
//}

-(id) initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder]) == nil) {
		return self;
    }
	
    maxX = 0;
	offset = 20;
	_pieces = [[NSMutableArray alloc] init];
	
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

- (void) scalePiece:(MJPiece*)piece {
	CGFloat pieceHeight = self.frame.size.height - (2.0f * offset);
	CGFloat scale = 1;
	if (piece.frame.size.height > pieceHeight) {
		scale = pieceHeight / piece.frame.size.height;
	}
	else if (piece.frame.size.height < pieceHeight) {
		scale = piece.frame.size.height / pieceHeight;
	}
	else return;
	
	[piece setFrame:CGRectMake(piece.frame.origin.x, piece.frame.origin.y, piece.frame.size.width * scale, pieceHeight)];
}

- (void) reloadToolbarStartingAtIndex:(NSUInteger)index {
	NSLog(@"Reloading Toolbar at Index: %i, %i", index, _pieces.count - 1);
	
	NSArray* tmp = nil;
	
	int length = _pieces.count - index;//min length is one
	
	tmp = [NSArray arrayWithArray:
		   [_pieces objectsAtIndexes:
			[NSIndexSet indexSetWithIndexesInRange:
			 NSMakeRange(index, length)]]];//min array is the last object
	NSLog(@"TMP Count: %i", tmp.count);
	[_pieces removeObjectsInArray:tmp];
	NSLog(@"Piece Count: %i", _pieces.count);
	
	MJPiece* lastObj = _pieces.lastObject;
	if (lastObj) {
		maxX = lastObj.frame.origin.x + lastObj.frame.size.width;
		[self setContentSize:CGSizeMake(maxX + offset, self.frame.size.height)];
	}
	else {
		maxX = 0;
	}
	for (MJPiece* p in tmp) {
		[p removeFromSuperview];
		[p setFrame:CGRectMake(maxX + offset, 
							   offset, 
							   p.frame.size.width, 
							   p.frame.size.height)];
		[self addSubview:p];
		maxX += p.frame.size.width + offset;
		[self setContentSize:CGSizeMake(maxX + offset, self.frame.size.height)];
		[_pieces addObject:p];
	}
}


#pragma mark - MJPieceDelegate Methods

- (BOOL) addPiece:(MJPiece*)piece {
	if (!piece) {
		return NO;
	}
	
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
		NSLog(@"Added Piece at end: %i", [_pieces indexOfObject:piece]);
		index = _pieces.count-1;
		//		[self addSubview:piece];
	}
	else {
		NSLog(@"Inserting Piece at index: %i of %i", index, _pieces.count);
		[_pieces insertObject:piece atIndex:index];
	}
	[self reloadToolbarStartingAtIndex:index];
	return YES;
}

- (BOOL) removePiece:(MJPiece*)piece {
	//	furthestRight -= piece.frame.size.width + offset;
	//	[piece removeFromSuperview];
	if (![_pieces containsObject:piece]) return false;
	
	int index = [_pieces indexOfObject:piece];
	NSLog(@"Removing piece at index: %i", index);
	[_pieces removeObject:piece];
	
	[self reloadToolbarStartingAtIndex:index];
	return YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	NSLog(@"Will Begin Dragging");
}

@end
