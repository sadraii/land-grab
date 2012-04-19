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
#import "MJBombResource.h"
#import "MJBombTile.h"

@implementation MJToolbar

@synthesize viewController = _viewController;
@synthesize player = _player;
@synthesize pieces = _pieces;
@synthesize inventoryCounter = _inventoryCounter;
@synthesize bombCounter = _bombCounter;
@synthesize realBombTile = _realBombTile;

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        offset = 20;
		pieceHeight = self.frame.size.height - (2 * offset);
		maxX = 0;
        MJInventoryCount *tmpInventoryCounter = [[MJInventoryCount alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _inventoryCounter = tmpInventoryCounter;
        _pieces = [[NSMutableArray alloc] init];
        _bombCounter = [[MJInventoryCount alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        
        
    }
    return self;
}

- (void) newGame {
	//[self removeAllPieces];
}

- (void) loadPlayer:(MJPlayer *)player {
    
   
    [self removeAllPiecesFor:player];

    [player updateNumberOfTilesToPlayWithNumber:1];
	[self placeAnotherTile:player];
    
    NSLog(@"Player %@ has %i bombs", player.handle, player.numberOfBombsToPlay);
    //[player updateNumberOfBombsToPlayWithNumber:0];
    //[self updateBombCounterWithNumber:player.numberOfBombsToPlay];
    if (player.numberOfBombsToPlay >= 1) {
        for (int i =0; i<player.numberOfBombsToPlay; i++) {
            [self addBombToToolBar:player];
        }
        
        [self updateBombCounterForPlayer:player];
        [self animateBombCounter];
    }
    
    else {
        [_realBombTile removeFromSuperview];
        _realBombTile.alpha = 0.0;
        [self fadeBombCounter];
    }
    

}

- (void) addBombToToolBar:(MJPlayer *)player {
    MJBombTile *tile = [[MJBombTile alloc] initWithCoordinate:CGPointZero];
    [tile setViewController:_viewController];
	[tile setBoard:_viewController.board];
	[tile setToolbar:_viewController.toolbar];
	[tile setPlayer:player];
	// Let's use the tag to differentiate the bomb vs. a normal tile
    [tile setTag:1];
    
    UIImage *image = [UIImage imageNamed:@"bomb_yellow.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:tile.bounds];
    [tile addSubview:imageView];
    

        [self addBombTile:tile];

    
}

- (void) placeAnotherTile:(MJPlayer *)player {
    MJTile * tile = [[MJTile alloc] initWithCoordinate:CGPointZero];
	[tile setViewController:_viewController];
	[tile setBoard:_viewController.board];
	[tile setToolbar:_viewController.toolbar];
	[tile setPlayer:player];
	[tile setTag:0];
    [self animateInventoryCounter];
    
    UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_Tile_TileSize.png", player.imageColor]];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:tile.bounds];
    [tile addSubview:imageView];
    
    
	[self addTile:tile];

}

- (void) animateInventoryCounter {
    [UIView animateWithDuration:0.1 animations:^ {
        _inventoryCounter.alpha = 1.0; 
    }completion:^(BOOL finished) {
        [self bringSubviewToFront:[_viewController.toolbar.inventoryCounter superview]];
        [[_viewController.toolbar.inventoryCounter superview] bringSubviewToFront:_viewController.toolbar.inventoryCounter]; 
    }];
}

- (void) fadeInventoryCounter {
    [UIView animateWithDuration:0.5 animations:^ {
        _inventoryCounter.alpha = 0.0; 
    }];
}

- (void) animateBombCounter {
    [UIView animateWithDuration:0.1 animations:^ {
        _bombCounter.alpha = 1.0;    
    }completion:^(BOOL finished) {
        [self bringSubviewToFront:[_viewController.toolbar.bombCounter superview]];
        [[_viewController.toolbar.bombCounter superview] bringSubviewToFront:_viewController.toolbar.bombCounter];
    }];
}

- (void) fadeBombCounter {
    [UIView animateWithDuration:0.1 animations:^ {
        _bombCounter.alpha = 0.0;
    }];
}

-(void)updateCounterWith:(NSUInteger)number {
    _inventoryCounter.counter.text = [NSString stringWithFormat:@"%d", number];
    NSLog(@"updateCounterWith %d tiles", number);
}

- (void)updateBombCounterForPlayer:(MJPlayer *)player {
    _bombCounter.counter.text = [NSString stringWithFormat:@"%d", player.numberOfBombsToPlay];
    NSLog(@"updateBombCounterWith %d bombs", player.numberOfBombsToPlay);
}

- (void) removeAllPiecesFor:(MJPlayer *)player {
	for (MJTile* t in _pieces) {
		[t removeFromSuperview];
	}
    for (MJBombTile *b in _pieces) {
        [b removeFromSuperview];
    }
}

- (void) addTile:(MJTile*)tile {
	
    if (tile.tag == 0) {
        [tile setFrame:CGRectMake(offset, offset, [MJBoard tileSize], [MJBoard tileSize])];
        [tile setIsPlayed:NO];
        [_inventoryCounter setCenter:CGPointMake(tile.frame.origin.x + tile.frame.size.width, tile.frame.origin.y)];
        [self addSubview:_inventoryCounter];
        [self addSubview:tile];
    }
    
 
}

- (void) addBombTile:(MJBombTile *)tile {
    if (tile.tag == 1) {
        _realBombTile = tile;
        [tile setFrame:CGRectMake(offset*6, offset, [MJBoard tileSize], [MJBoard tileSize])];
        [tile setIsPlayed:NO];
        [_bombCounter setCenter:CGPointMake(tile.frame.origin.x + tile.frame.size.width, tile.frame.origin.y)];
        [self fadeBombCounter];
        [self addSubview:_bombCounter];
        [self animateBombCounter];
        [_pieces addObject:tile];
        [self addSubview:tile];
    }
}
@end
