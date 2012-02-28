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
#import "MJTile.h"

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

- (void) insertPiece:(id) piece AtIndex:(NSUInteger)index {
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
		maxX = p.origin.x + p.size.width;
		NSLog(@"Toolbar: (%f, %f)", p.origin.x, p.origin.y);
		
		[_pieces addObject:p];
		[p addAsSubviewToView:self];
	}
}

- (void) loadPlayer:(MJPlayer *)player {
	if ([player isEqual:_player]) abort();
	[self removeAllPieces];
	MJTile * tile = [[MJTile alloc] initWithCoordinate:CGPointZero];
	[tile setViewController:_viewController];
	[tile setBoard:_viewController.board];
	[tile setToolbar:_viewController.toolbar];
	[tile setPlayer:player];
	[tile setBackgroundColor:player.color];
	[self addPiece:tile];
	
	for (MJPiece* p  in player.pieces) {
//		MJPiece* lastPiece = [_pieces lastObject];
//		if (lastPiece) {
//			//Force the piece to insert at end of _pieces array
//			[p setOrigin:CGPointMake(maxX + lastPiece.origin.x + lastPiece.size.width, p.origin.y)];
//		}
//		[self addPiece:p];
	}
}

- (void) removeAllPieces {
	for (id p in _pieces) {
		
	}
}

#pragma mark - Piece Delegate

- (void) addPiece:(id)piece {
	int index = 0;
	if ([piece isKindOfClass:[MJTile class]]) {
		MJTile* tile = (MJTile*)piece;
		[tile setFrame:CGRectMake(offset, offset, TILE_SIZE, TILE_SIZE)];
		[tile setIsPlayed:NO];
		[self addSubview:tile];
	}
	else if ([piece isKindOfClass:[MJPiece class]]) {
		MJPiece* piece = (MJPiece*)piece;
		for (MJPiece* p in _pieces) {
			if ((p.size.width / 2) < piece.lastTouch.x)	break;
			index++;
		}
		if ([piece isMemberOfClass:NSClassFromString(@"MJPiece")]) {
			[self insertPiece:(MJPiece*) piece AtIndex:index];
		}
	}
	else abort();
}

- (void) removePiece:(MJPiece*)piece {
	if ([piece isKindOfClass:[MJTile class]]) {
		MJTile* tile = (MJTile*)piece;
	}
	else if ([piece isKindOfClass:[MJPiece class]]) {
		MJPiece* piece = (MJPiece*)piece;
	}
	else abort();
}
@end
