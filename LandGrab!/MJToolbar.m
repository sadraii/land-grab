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

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        offset = 20;
		pieceHeight = self.frame.size.height - (2 * offset);
		maxX = 0;
        MJInventoryCount *tmpInventoryCounter = [[MJInventoryCount alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _inventoryCounter = tmpInventoryCounter;
        
        _bombCounter = [[MJInventoryCount alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        
        
    }
    return self;
}

- (void) newGame {
	[self removeAllPieces];
}

- (void) loadPlayer:(MJPlayer *)player {
    
    [self removeAllPieces];
	
//	//Add a single tile to the first index of the board
//	MJTile * tile = [[MJTile alloc] initWithCoordinate:CGPointZero];
//	[tile setViewController:_viewController];
//	[tile setBoard:_viewController.board];
//	[tile setToolbar:_viewController.toolbar];
//	[tile setPlayer:player];
//	[tile setTag:0];
    [player updateNumberOfTilesToPlayWithNumber:1];
	[self placeAnotherTile:player];
    
	//[tile setBackgroundColor:player.color];
//    for (int i = 0; i < player.numberOfBombsToPlay; i++) {
//        [self addBombToToolBar:player];
//    }
    [player updateNumberOfBombsToPlayWithNumber:0];
    //[self updateBombCounterWithNumber:player.numberOfBombsToPlay];
    [self addBombToToolBar:player];
//    UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_Tile_TileSize.png", player.imageColor]];
//    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
//    [imageView setFrame:tile.bounds];
//    [tile addSubview:imageView];
//    
//	[self addTile:tile];
}

- (void) addBombToToolBar:(MJPlayer *)player {
    MJBombTile *tile = [[MJBombTile alloc] initWithCoordinate:CGPointZero];
    [tile setViewController:_viewController];
	[tile setBoard:_viewController.board];
	[tile setToolbar:_viewController.toolbar];
	[tile setPlayer:player];
	// Let's use the tag to differentiate the bomb vs. a normal tile
    [tile setTag:1];
    
    UIImage *image = [UIImage imageNamed:@"Resource_Green.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:tile.bounds];
    [tile addSubview:imageView];
    
    [self addTile:tile];
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

- (void)updateBombCounterWithNumber:(NSUInteger)number {
    _bombCounter.counter.text = [NSString stringWithFormat:@"%d", number];
    NSLog(@"updateBombCounterWith %d bombs", number);
}

- (void) removeAllPieces {
	for (MJTile* t in _pieces) {
		[t removeFromSuperview];
	}
    for (MJBombResource *b in _pieces) {
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
    
    if (tile.tag == 1) {
        [tile setFrame:CGRectMake(offset*6, offset, [MJBoard tileSize], [MJBoard tileSize])];
        [tile setIsPlayed:NO];
        [_bombCounter setCenter:CGPointMake(tile.frame.origin.x + tile.frame.size.width, tile.frame.origin.y)];
        [self fadeBombCounter];
        [self addSubview:_bombCounter];
        [self animateBombCounter];
        [self addSubview:tile];
    }
}
@end
