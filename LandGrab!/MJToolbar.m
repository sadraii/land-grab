//
//  MJToolbar.m
//  LandGrab!
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJToolbar.h"
#import "MJBoard.h"
#import "MJViewController.h"
#import "MJPlayer.h"
#import "MJTile.h"
#import "MJInventoryCount.h"

@implementation MJToolbar

@synthesize viewController = _viewController;
@synthesize player = _player;
@synthesize pieces = _pieces;
@synthesize inventoryCounter = _inventoryCounter;

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        offset = 20;
		pieceHeight = self.frame.size.height - (2 * offset);
		maxX = 0;
        
    }
    return self;
}

- (void) newGame {
	[self removeAllPieces];
}

- (void) loadPlayer:(MJPlayer *)player {
 
    [self removeAllPieces];
	
	//Add a single tile to the first index of the board
	MJTile * tile = [[MJTile alloc] initWithCoordinate:CGPointZero];
	[tile setViewController:_viewController];
	[tile setBoard:_viewController.board];
	[tile setToolbar:_viewController.toolbar];
	[tile setPlayer:player];
	[tile setTag:0];
	//[tile setBackgroundColor:player.color];

    
    
    UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_Tile_TileSize.png", player.imageColor]];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:tile.bounds];
    [tile addSubview:imageView];
    
    
	[self addTile:tile];
    MJInventoryCount *tmpInventoryCounter = [[MJInventoryCount alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _inventoryCounter = tmpInventoryCounter;
    [_inventoryCounter setCenter:CGPointMake(tile.frame.origin.x + tile.frame.size.width, tile.frame.origin.y)];
    [self addSubview:_inventoryCounter];
}

- (void) removeAllPieces {
	for (MJTile* t in _pieces) {
		[t removeFromSuperview];
	}
}

- (void) addTile:(MJTile*)tile {
	[tile setFrame:CGRectMake(offset, offset, [MJBoard tileSize], [MJBoard tileSize])];
	[tile setIsPlayed:NO];
	[self addSubview:tile];
}
@end
