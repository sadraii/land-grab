//
//  MJBoard.m
//  LandGrab!
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJBoard.h"
#import "MJViewController.h"
#import "MJContainerView.h"
#import "MJPlayer.h"
#import "MJPiece.h"
#import "MJTile.h"

@implementation MJBoard

@synthesize viewController = _viewController;
@synthesize pieces = _pieces;
@synthesize boardSize = _boardSize; 
@synthesize containerView = _containerView;

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setPieces:NULL];
        _boardSize = CGSizeZero;
        _containerView = NULL;
        [self newGame];
        
    }
    return self;
}

- (void) newGame
{
	_containerView = NULL;
	_pieces = [[NSMutableArray alloc] init];
	[self setBoardSize:CGSizeMake(12, 12)];
}

- (void) setBoardSize:(CGSize)size
{
	CGRect frame = CGRectMake(0, 0, size.width*TILE_SIZE, size.height*TILE_SIZE);
	if (!_containerView) {
		_containerView = [[MJContainerView alloc] initWithFrame:frame];
		_containerView.board = self;
		[self addSubview:_containerView];
	}
	[self setContentSize:frame.size];
	_boardSize = size;
}

- (MJTile*) tileAtCoordinate:(CGPoint)coordinate {
	
	for (MJTile* t in _pieces)
		if (CGPointEqualToPoint(coordinate, t.coordinate)) return t;
	return nil;
}

- (BOOL) isCoordinateOnBoard:(CGPoint)coordinate {
	if (coordinate.x < 0 || coordinate.x > _boardSize.width - 1) return NO;
	if (coordinate.y < 0 || coordinate.y > _boardSize.height - 1) return NO;
	return YES;
}

#pragma mark - Scroll View Delegate Methods

- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return _containerView;
}

#pragma mark - Piece Delegate

- (void) addPiece:(id)piece {
	if ([piece isKindOfClass:[MJTile class]]) {
		MJTile* tile = (MJTile*)piece;
		[tile snapToPoint];
		if ([self tileAtCoordinate:tile.coordinate]) {
			NSLog(@"Cannot place a piece on top of another");
			[tile touchesCancelled:nil withEvent:nil];
			return;
		}
		else if(![self isCoordinateOnBoard:tile.coordinate]) {
			NSLog(@"Cannot place a piece off the board;");
			[tile touchesCancelled:nil withEvent:nil];
			return;
		}
		[tile setIsPlayed:YES];
		[tile setUserInteractionEnabled:NO];
		[_containerView addSubview:tile];
		
		MJPlayer* player = _viewController.currentPlayer;
		[player setLastPlayedTile:tile];
		[[player playedPieces] addObject:tile];
		[_pieces addObject:tile];
		NSLog(@"MJBoard: Played Pieces Count: %i", player.playedPieces.count);
	}
	else if ([piece isKindOfClass:[MJPiece class]]) {
		MJPiece* piece = (MJPiece*)piece;
		CGPoint newOrigin = piece.origin;
		newOrigin.x -= self.frame.origin.x;
		newOrigin.y -= self.frame.origin.y;
		[piece setOrigin:newOrigin];
		[piece snapToPoint];
		[piece setIsPlayed:YES];
		
		[piece addAsSubviewToView:_containerView];
	}
	else abort();
	
	[_viewController nextPlayer];
}

- (void) removePiece:(id)piece {
	if ([piece isKindOfClass:[MJTile class]]) {
		MJTile* tile = (MJTile*)piece;
	}
	else if ([piece isKindOfClass:[MJPiece class]]) {
		MJPiece* piece = (MJPiece*)piece;
	}
	else abort();
}

@end
