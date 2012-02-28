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
	[self setBoardSize:CGSizeMake(30, 30)];
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

- (void) scalePiece:(MJPiece*)piece
{
    
}

- (CGPoint) originOfPiece:(MJPiece*)piece
{
    
}

#pragma mark - Scroll View Delegate Methods

- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return _containerView;
}

#pragma mark - Piece Delegate

- (void) addPiece:(id)piece {
	if ([piece isKindOfClass:[MJTile class]]) {
		MJTile* tile = (MJTile*)piece;
//		CGPoint newOrigin = tile.frame.origin;
//		newOrigin.x -= self.frame.origin.x;
//		newOrigin.y -= self.frame.origin.y;
//		[tile setFrame:CGRectMake(newOrigin.x, newOrigin.y, tile.frame.size.width, tile.frame.size.height)];
		[tile snapToPoint];
		[tile setIsPlayed:YES];
		[tile setUserInteractionEnabled:NO];
		
		[_containerView addSubview:tile];

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
