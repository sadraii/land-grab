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
#import "MJTile.h"
#import "MJResource.h"
#import "MJToolbar.h"
#import "MJInventoryCount.h"


@implementation MJBoard

@synthesize viewController  = _viewController;

@synthesize pieces          = _pieces;
@synthesize resources       = _resources;

@synthesize boardSize       = _boardSize; 
@synthesize containerView   = _containerView;

+ (NSUInteger) tileSize {
	NSString* deviceName = [UIDevice currentDevice].model;
	if ([deviceName isEqualToString:@"iPhone Simulator"] || [deviceName isEqualToString:@"iPhone"]) {
		return 32;
	}
	return 64;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _pieces = NULL;
		_resources = NULL;
        _boardSize = CGSizeZero;
        _containerView = NULL;
		
        [self newGame];
		
		[super setDelegate:self];
    }
    return self;
}

- (void) newGame
{
	if (_containerView) {
		[_containerView removeFromSuperview];
	}
	_containerView = NULL;
	_pieces = [[NSMutableArray alloc] init];
	_resources = [[NSMutableArray alloc] init];
	
}

- (void) setBoardSize:(CGSize)size
{
	CGRect frame = CGRectMake(0, 0, size.width*[MJBoard tileSize], size.height*[MJBoard tileSize]);
	if (!_containerView) {
		_containerView = [[MJContainerView alloc] initWithFrame:frame];
		_containerView.board = self;
		[self addSubview:_containerView];
	}
	[self setContentSize:frame.size];
	_boardSize = size;
	[self updateZoomScale];
}

- (MJTile*) tileAtCoordinate:(CGPoint)coordinate {
	
	for (MJTile* t in _pieces)
		if (CGPointEqualToPoint(coordinate, t.coordinate)) return t;
	return nil;
}

- (MJResource*) resourceAtCoordinate:(CGPoint)coordinate {
	for (MJResource* r in _resources){
		if (CGPointEqualToPoint(coordinate, r.coordinate)) {
			
			return r;
		}
	}
	return nil;
}

- (BOOL) resourcesAroundCoordinate:(CGPoint)coordinate {
    CGPoint up = CGPointMake(coordinate.x, coordinate.y + 1);
	CGPoint down = CGPointMake(coordinate.x, coordinate.y - 1);
	CGPoint left = CGPointMake(coordinate.x - 1, coordinate.y);
	CGPoint right = CGPointMake(coordinate.x + 1, coordinate.y);
    CGPoint upLeft = CGPointMake(coordinate.x - 1, coordinate.y + 1);
    CGPoint upRight = CGPointMake(coordinate.x + 1, coordinate.y + 1);
    CGPoint downLeft = CGPointMake(coordinate.x - 1, coordinate.y - 1);
    CGPoint downRight = CGPointMake(coordinate.x + 1, coordinate.y - 1);
	
	MJResource *tmp = nil;
	
	if ( (tmp = [self resourceAtCoordinate:up]) || (tmp = [self resourceAtCoordinate:down]) || (tmp = [self resourceAtCoordinate:left]) || (tmp = [self resourceAtCoordinate:right])
        || (tmp = [self resourceAtCoordinate:upLeft]) || (tmp = [self resourceAtCoordinate:upRight]) || (tmp = [self resourceAtCoordinate:downLeft]) || (tmp = [self resourceAtCoordinate:downRight]) ){
		return YES;
	}
	
    return NO;
}

- (BOOL) isCoordinateOnBoard:(CGPoint)coordinate {
	if (coordinate.x < 0 || coordinate.x > _boardSize.width - 1) return NO;
	if (coordinate.y < 0 || coordinate.y > _boardSize.height - 1) return NO;
	return YES;
}

- (void) updateZoomScale {
	CGFloat scale = self.bounds.size.width / _containerView.bounds.size.width;
	if (self.zoomScale < scale || self.zoomScale > 1) {
        //		[self setZoomScale:scale animated:YES];
		[self zoomOutAnimated:YES];
	}
	[self setMinimumZoomScale:scale];
	[self setMaximumZoomScale:1];
	NSLog(@"Set MinimumZoomScale: %f", scale);
}

- (void) zoomOutAnimated:(BOOL)animated {
	if (self.zoomScale == self.minimumZoomScale) {
		NSLog(@"Already zoomed out");
		return;
	}
	if (animated) {
		[UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^ {
			[self setZoomScale:self.minimumZoomScale animated:NO];	
		}completion:^(BOOL finished) {
            //		[containerView setNeedsDisplay];
			
		}];
	}
	else {
		[self setZoomScale:self.minimumZoomScale animated:NO];
	}
}

#pragma mark - Add Methods
- (void) addTile:(MJTile*)tile {
	
	//Check if tile is placed Off the Board
	if(![self isCoordinateOnBoard:tile.coordinate]) {
		NSLog(@"Cannot place a tile off the board;");
		[tile touchesCancelled:nil withEvent:nil];
        
        [self bringSubviewToFront:[_viewController.toolbar.inventoryCounter superview]];
        [[_viewController.toolbar.inventoryCounter superview] bringSubviewToFront:_viewController.toolbar.inventoryCounter];
        
		return;
	}
	
	// Check if tile is placed ontop of one of your own tiles
	MJTile* tileCollision = [self tileAtCoordinate:tile.coordinate];
	if (tile.player == tileCollision.player) {
		NSLog(@"Cannot place a piece on top of your own piece");
		[tile touchesCancelled:nil withEvent:nil];
        
        // IMPORTANT NOTE! this is the proper way to keep the invetoryCounter ontop of ANY view of the tile, or any other subsequent tiles we may add to the tool bar, PLEASE DUPLICATE THESE TWO LINES OF CODE WHEN NECESSARY (whenever touchesCanceled is called)!
        
        [self bringSubviewToFront:[_viewController.toolbar.inventoryCounter superview]];
        [[_viewController.toolbar.inventoryCounter superview] bringSubviewToFront:_viewController.toolbar.inventoryCounter];
        
		return;
	}
	
	// Check if tile is placed ontop of another player's tile
	else if (tileCollision && tile.player != tileCollision.player) {
		NSLog(@"Collision with %@'s tile", tileCollision.player.handle);
        [tile touchesCancelled:nil withEvent:nil];
        [self bringSubviewToFront:[_viewController.toolbar.inventoryCounter superview]];
        [[_viewController.toolbar.inventoryCounter superview] bringSubviewToFront:_viewController.toolbar.inventoryCounter];
		return;
	}
	
	BOOL isTileConnected = [self isTileConnectedTo:tile];
	
	if (isTileConnected) {
		//Set the appropriate tile flags
		[tile setIsPlayed:YES];
		[tile setUserInteractionEnabled:NO];
		tile.tag=1;
		//Add it to the board (container view)
		[_containerView addSubview:tile];
		
		//Add tile to the current player
		MJPlayer* player = _viewController.currentPlayer;
		[player setLastPlayedTile:tile];
		[tile setPlayer:player];
		[player.playedPieces addObject:tile];
		[_pieces addObject:tile];
		
		MJResource* resourceCollision = [self resourceAtCoordinate:tile.coordinate];
		if (resourceCollision) {
			tile.player.score += resourceCollision.value;
			NSLog(@"%@ found a resource worth %i bananas!", tile.player.handle, resourceCollision.value);
		}
		
		[player updateScore];
		[_viewController performSelector:@selector(nextPlayer) withObject:nil afterDelay:1.0];
	}
	else {
		[tile touchesCancelled:nil withEvent:nil];
        [self bringSubviewToFront:[_viewController.toolbar.inventoryCounter superview]];
        [[_viewController.toolbar.inventoryCounter superview] bringSubviewToFront:_viewController.toolbar.inventoryCounter];
	}
}

- (void) addResource:(MJResource*)resource {
    //	NSLog(@"Resources: %i", _resources.count);
	[_resources addObject:resource];
	[_containerView addSubview:resource];
}

- (BOOL) isTileConnectedTo:(MJTile*)selfTerritory; {
	CGPoint up = CGPointMake(selfTerritory.coordinate.x, selfTerritory.coordinate.y + 1);
	NSLog(@"Point: (%f, %f)", selfTerritory.coordinate.x, selfTerritory.coordinate.y);
	CGPoint down = CGPointMake(selfTerritory.coordinate.x, selfTerritory.coordinate.y - 1);
	CGPoint left = CGPointMake(selfTerritory.coordinate.x - 1, selfTerritory.coordinate.y);
	CGPoint right = CGPointMake(selfTerritory.coordinate.x + 1, selfTerritory.coordinate.y);
	
	MJTile *tmp = nil;
	
	BOOL tmpBool = NO;
	
	if ((tmp = [self tileAtCoordinate:up]) && [tmp.player isEqual:selfTerritory.player] && tmp.tag == 1) {
		tmpBool = YES;
		NSLog(@"Tile is connected on the Top!");
	}
	if ((tmp = [self tileAtCoordinate:down]) && [tmp.player isEqual:selfTerritory.player] && tmp.tag == 1) {
		tmpBool = YES;
		NSLog(@"Tile is connected on the Bottom!");
	}
	if ((tmp = [self tileAtCoordinate:left]) && [tmp.player isEqual:selfTerritory.player] && tmp.tag == 1) {
		tmpBool = YES;
		NSLog(@"Tile is connected on the Right!");
	}
	if ((tmp = [self tileAtCoordinate:right]) && [tmp.player isEqual:selfTerritory.player] && tmp.tag == 1) {
		tmpBool = YES;
		NSLog(@"Tile is connected on the Left!");
	}
	
	if (!tmpBool) {
		NSLog(@"Tile NOT connected!");
	}
	
	return tmpBool;
    
}


#pragma mark - Scroll View Delegate Methods

- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return _containerView;
}

- (void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
	
}

#pragma mark - Overridden Methods

- (void) scrollRectToVisible:(CGRect)rect animated:(BOOL)animated {
	__block CGRect boardRect = self.bounds;
	boardRect.origin.x = (rect.origin.x + (rect.size.width / 2)) - (boardRect.size.width / 2);
	boardRect.origin.y = (rect.origin.y + (rect.size.height / 2)) - (boardRect.size.height / 2);
	if (animated) {
		[UIView animateWithDuration:0.5f delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^ {
			[self setZoomScale:1];
			[super scrollRectToVisible:boardRect animated:NO];
		}completion:^(BOOL finished) {
            
		}];
	}
	else {
		[self setZoomScale:1 animated:YES];
		[super scrollRectToVisible:boardRect animated:YES];
	}
}

@end
