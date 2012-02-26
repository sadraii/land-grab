//
//  MJToolbar.m
//  LandGrab!
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJToolbar.h"
#import "MJPiece.h"
#import "MJViewController.h"
#import "MJPlayer.h"

@implementation MJToolbar

@synthesize viewController = _viewController;
@synthesize player = _player;
@synthesize pieces = _pieces;

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        offset = 10;
		pieceHeight = self.frame.size.height - (2 * offset);
		maxX = 0;
    }
    return self;
}


- (void) snapPieceToPoint:(MJPiece*)piece {
	
}

- (void) insertPiece:(MJPiece*) piece AtIndex:(NSUInteger)index {
	NSLog(@"Inserting Piece at index: %i", index);
	NSArray* tmp = nil;
	
	if (index != 0) {
		[_pieces insertObject:piece atIndex:index];
		tmp = [NSArray arrayWithArray:[_pieces objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, _pieces.count - index)]]];
		[_pieces removeObjectsInArray:tmp];
		MJPiece* lastPiece = (MJPiece*)[_pieces lastObject];
		maxX = lastPiece.origin.x + lastPiece.size.width;
	}
	else {
		[_pieces addObject:piece];
		tmp = [NSArray arrayWithArray:_pieces];
		[self setPieces:nil];
		_pieces = [[NSMutableArray alloc] init];
		maxX = 0;
	}
	
	for (int i = 0; i < tmp.count; i++) {
		MJPiece* p = [tmp objectAtIndex:i];
		[p setOrigin:CGPointMake(maxX + offset, offset)];
		NSLog(@"Toolbar: (%f, %f)", p.origin.x, p.origin.y);
		[_pieces addObject:p];
		[p addAsSubviewToView:self];
	}
}

- (void) loadPlayer:(MJPlayer *)player {
	if ([player isEqual:_player]) return;
	[self removeAllPieces];
	for (MJPiece* p  in player.pieces) {
		MJPiece* lastPiece = [_pieces lastObject];
		if (lastPiece) {
			//Force the piece to insert at end of _pieces array
			[p setOrigin:CGPointMake(maxX + lastPiece.origin.x + lastPiece.size.width, p.origin.y)];
		}
		[self addPiece:p];
	}
}

- (void) removeAllPieces {
	for (MJPiece* p in _pieces) {
		[p removeFromSuperview];
	}
}

#pragma mark - Piece Delegate

- (void) addPiece:(MJPiece*)piece {
	int index = 0;
	for (MJPiece* p in _pieces) {
		if ((p.size.width / 2) < piece.lastTouch.x)	break;
		index++;
	}
	[self insertPiece:piece AtIndex:index];
}

- (void) removePiece:(MJPiece*)piece {
	
}
@end
