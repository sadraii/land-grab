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
#import "MJAddTilesResource.h"
#import "MJBombResource.h"
#import "MJClusterResource.h"
#import "MJNegativeResource.h"
#import "MJBombTile.h"
#import <QuartzCore/QuartzCore.h>


@implementation MJBoard

@synthesize viewController  = _viewController;

@synthesize pieces          = _pieces;
@synthesize resources       = _resources;

@synthesize boardSize       = _boardSize; 
@synthesize containerView   = _containerView;
@synthesize tileToRemove    = _tileToRemove;

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

- (void) removeTileAtCoordinate:(CGPoint)coordinate {
    for (MJTile* t in _pieces) {
        if (CGPointEqualToPoint(coordinate, t.coordinate)) {
            _tileToRemove = t;
        }
    }
    [_pieces removeObjectIdenticalTo:_tileToRemove];
}

- (MJBombTile*) bombAtCoordinate:(CGPoint)coordinate {
    for (MJBombTile* t in _pieces)
		if (CGPointEqualToPoint(coordinate, t.coordinate)) return t;
	return nil;
}


// I think we need to make this id to deal with the different subclassed resources
// I'm keeping a copy commented so that we can use it back if everything breaks.
/*
- (MJResource*) resourceAtCoordinate:(CGPoint)coordinate {
	for (MJResource* r in _resources){
		if (CGPointEqualToPoint(coordinate, r.coordinate)) {
			
			return r;
		}
	}
	return nil;
}
*/

- (id) resourceAtCoordinate:(CGPoint)coordinate {
	NSUInteger index = 0;
    for (id r in _resources) {
        
		if ([r isMemberOfClass:[MJResource class]]) {
            MJResource *tmpR = [_resources objectAtIndex:index];
            if (CGPointEqualToPoint(coordinate, tmpR.coordinate)) {
                return tmpR;
            }
        }
        if ([r isMemberOfClass:[MJAddTilesResource class]]) {
            MJAddTilesResource *tmpR = [_resources objectAtIndex:index];
            if (CGPointEqualToPoint(coordinate, tmpR.coordinate)) {
                return tmpR;
            }
        }
        
        if ([r isMemberOfClass:[MJBombResource class]]) {
            MJBombResource *tmpR = [_resources objectAtIndex:index];
            if (CGPointEqualToPoint(coordinate, tmpR.coordinate)) {
                return tmpR;
            }
        }
        
        if ([r isMemberOfClass:[MJNegativeResource class]]) {
            MJNegativeResource *tmpR = [_resources objectAtIndex:index];
            if (CGPointEqualToPoint(coordinate, tmpR.coordinate)) {
                return tmpR;
            }
        }
        
        if ([r isMemberOfClass:[MJClusterResource class]]) {
            MJClusterResource *tmpR = [_resources objectAtIndex:index];
            if (CGPointEqualToPoint(coordinate, tmpR.coordinate)) {
                return tmpR;
            }
        }
        index++;  
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

- (void) addBombTile:(MJBombTile *)tile {
    
    NSLog(@"THIS SHIT WORKED YAY!");
    
    if(![self isCoordinateOnBoard:tile.coordinate]) {
		NSLog(@"Cannot place a tile off the board;");
		[tile touchesCancelled:nil withEvent:nil];
        [tile.toolbar animateBombCounter];
        
		return;
	}
	
	// Check if tile is placed ontop of one of your own tiles
	MJTile* tileCollision = [self tileAtCoordinate:tile.coordinate];
	if (tile.player == tileCollision.player) {
		NSLog(@"Cannot place a bomb on top of your own piece");
		[tile touchesCancelled:nil withEvent:nil];
        
        // IMPORTANT NOTE! this is the proper way to keep the invetoryCounter ontop of ANY view of the tile, or any other subsequent tiles we may add to the tool bar, PLEASE DUPLICATE THESE TWO LINES OF CODE WHEN NECESSARY (whenever touchesCanceled is called)!
        
        [tile.toolbar animateBombCounter];
        
		return;
	}
    
    else if (tileCollision == nil) {
        NSLog(@"Cannot place a bomb on empty space");
		[tile touchesCancelled:nil withEvent:nil];
        
        // IMPORTANT NOTE! this is the proper way to keep the invetoryCounter ontop of ANY view of the tile, or any other subsequent tiles we may add to the tool bar, PLEASE DUPLICATE THESE TWO LINES OF CODE WHEN NECESSARY (whenever touchesCanceled is called)!
        
        [tile.toolbar animateBombCounter];
        
		return;
    }
    
    else if (tileCollision && tile.player != tileCollision.player && tileCollision != tileCollision.player.capital) {
        
        [tile.player subtractBomb];
        
        NSLog(@"Bombed %@'s tile!", tileCollision.player.handle);
        MJTile* tileToRemove = [self tileAtCoordinate:tile.coordinate];
        //[self bombAnimationWith:tileToRemove];
        [self shakeTile:tileToRemove];
        [self performSelector:@selector(bombAnimationWith:) withObject:tileToRemove afterDelay:0.4];
        //[tileToRemove removeFromSuperview];
        [self removeTileAtCoordinate:tileToRemove.coordinate];
        
        [tile removeFromSuperview];
        [tile.toolbar animateBombCounter];
    
	}
    else {
        [tile touchesCancelled:nil withEvent:nil];
    }
    
    if (tile.player.numberOfBombsToPlay < 1) {
        [tile.toolbar fadeBombCounter];
        [tile.toolbar.realBombTile removeFromSuperview];
    }
}

- (void) addTile:(MJTile*)tile {

	//Check if tile is placed Off the Board
	if(![self isCoordinateOnBoard:tile.coordinate]) {
		NSLog(@"Cannot place a tile off the board;");
		[tile touchesCancelled:nil withEvent:nil];
        [tile.toolbar animateInventoryCounter];
        
		return;
	}
	
	// Check if tile is placed ontop of one of your own tiles
	MJTile* tileCollision = [self tileAtCoordinate:tile.coordinate];
	if (tile.player == tileCollision.player) {
		NSLog(@"Cannot place a piece on top of your own piece");
		[tile touchesCancelled:nil withEvent:nil];
        
        // IMPORTANT NOTE! this is the proper way to keep the invetoryCounter ontop of ANY view of the tile, or any other subsequent tiles we may add to the tool bar, PLEASE DUPLICATE THESE TWO LINES OF CODE WHEN NECESSARY (whenever touchesCanceled is called)!
        
        [tile.toolbar animateInventoryCounter];
        
		return;
	}
	
	// Check if tile is placed ontop of another player's tile
	else if (tileCollision && tile.player != tileCollision.player) {
//		if (<#condition#>) {
//            <#statements#>
//        }
        NSLog(@"Collision with %@'s tile", tileCollision.player.handle);
        [tile touchesCancelled:nil withEvent:nil];
        [tile.toolbar animateInventoryCounter];
		return;
	}
	
	BOOL isTileConnected = [self isTileConnectedTo:tile];
	
 
	if (!isTileConnected) {
        [tile touchesCancelled:nil withEvent:nil];
        [tile.toolbar animateInventoryCounter];
	}
	else {
        if (tile.player.numberOfTilesToPlay >= 1) {
            [tile.player subtractTile];
        }
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
        didRecieveResource = NO;
		
		id resourceCollision = [self resourceAtCoordinate:tile.coordinate];
        
        NSLog(@"%@",tile.tileConnected);
        
		if ([resourceCollision isMemberOfClass:[MJResource class]]) {
			MJResource *tmpResource = [self resourceAtCoordinate:tile.coordinate];
            tile.player.score += tmpResource.value;
			NSLog(@"%@ found a resource worth %i bananas!", tile.player.handle, tmpResource.value);
            [self animatePositivePointResources:tmpResource.value:tile];
            didRecieveResource = YES;
            [player updateScore];
		}
        
        if ([resourceCollision isMemberOfClass:[MJAddTilesResource class]]) {
            MJResource *tmpResource = [self resourceAtCoordinate:tile.coordinate];
            NSLog(@"%@ found an AddTile resource worth %i tiles!", tile.player.handle, [(MJAddTilesResource*)tmpResource tilesGenerated]);
            [tile.player updateNumberOfTilesToPlayWithNumber:[(MJAddTilesResource*)tmpResource tilesGenerated]];
            [tile.toolbar animateInventoryCounter];
            [self animateAddTileResources:[(MJAddTilesResource*)tmpResource tilesGenerated]:tile];
        }
        
        if ([resourceCollision isMemberOfClass:[MJBombResource class]]) {
            MJBombResource *tmpResource = (MJBombResource*)[self resourceAtCoordinate:tile.coordinate];
            NSLog(@"%@ found an Bomb resource worth %i bombs!", tile.player.handle, tmpResource.bombs);
            [tile.player updateNumberOfBombsToPlayWithNumber:tmpResource.bombs];
            didRecieveResource = YES;
            [self animateBombResources:1 :tile];
            //MJBombTile *tmpBombTile = [[MJBombTile alloc] init];
            //[tile.player.toolBarPieces addObject:tmpBombTile];
            [tile.toolbar addBombToToolBar:tile.player];
            [tile.toolbar animateBombCounter];
        }
        
        if ([resourceCollision isMemberOfClass:[MJClusterResource class]]) {
            MJClusterResource *tmpResource = (MJClusterResource*)[self resourceAtCoordinate:tile.coordinate];
            NSLog(@"%@ found a cluster resource worth %i tiles!", tile.player.handle, [(MJClusterResource*)tmpResource generateTiles]);
            [self addClusterTilesWith:tile];
            
        }
        
        if ([resourceCollision isMemberOfClass:[MJNegativeResource class]]) {
            MJNegativeResource *tmpResource = (MJNegativeResource*)[self resourceAtCoordinate:tile.coordinate];
            NSLog(@"%@ aww found a negative resource worth %i points", tile.player.handle, tmpResource.value);
            [self animateNegativePointResources:tmpResource.value :tile];
            tile.player.score += tmpResource.value;
            didRecieveResource = YES;
            [player updateScore];
        }
		
		if (tile.player.numberOfTilesToPlay < 1 && didRecieveResource) {
            [_viewController performSelector:@selector(nextPlayer) withObject:nil afterDelay:0.75];
        }
        else if(tile.player.numberOfTilesToPlay < 1 && !didRecieveResource) {
            [_viewController performSelector:@selector(nextPlayer) withObject:nil afterDelay:0.25];
        }
        else {
            [tile.toolbar placeAnotherTile:tile.player];
        }
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
        selfTerritory.tileConnected = [NSString stringWithString:@"up"];
		NSLog(@"Tile is connected on the Top!");
	}
	if ((tmp = [self tileAtCoordinate:down]) && [tmp.player isEqual:selfTerritory.player] && tmp.tag == 1) {
		tmpBool = YES;
        selfTerritory.tileConnected = [NSString stringWithString:@"down"];
		NSLog(@"Tile is connected on the Bottom!");
	}
	if ((tmp = [self tileAtCoordinate:left]) && [tmp.player isEqual:selfTerritory.player] && tmp.tag == 1) {
		tmpBool = YES;
        selfTerritory.tileConnected = [NSString stringWithString:@"right"];
		NSLog(@"Tile is connected on the Right!");
	}
	if ((tmp = [self tileAtCoordinate:right]) && [tmp.player isEqual:selfTerritory.player] && tmp.tag == 1) {
		tmpBool = YES;
        selfTerritory.tileConnected = [NSString stringWithString:@"left"];
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

#pragma mark - animate Methods

- (void) animatePositivePointResources:(NSUInteger)withValue:(MJTile*)tile {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(tile.player.lastPlayedTile.coordinate.x*64 - 25, tile.player.lastPlayedTile.coordinate.y*64, 400, 200)];
          
    label.text =[NSString stringWithFormat:@"+%i", withValue];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:90.0];
    label.alpha = 1.0;
    label.backgroundColor = [UIColor clearColor];
    
    [self addSubview:label];
    
    
    [UIView animateWithDuration:0.85 delay:0.0 options:UIViewAnimationCurveEaseIn animations:^ {
        label.alpha = 0.0; 
        label.transform = CGAffineTransformTranslate(label.transform, 0, -300);
    }completion:^(BOOL finished) {
        
        [label removeFromSuperview]; 
        
    }];
}

- (void) animateNegativePointResources:(NSUInteger)withValue:(MJTile*)tile {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(tile.player.lastPlayedTile.coordinate.x*64 - 25, tile.player.lastPlayedTile.coordinate.y*64, 400, 200)];
    
    label.text =[NSString stringWithFormat:@"%i", withValue];
    label.textColor = [UIColor redColor];
    label.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:95.0];
    label.alpha = 1.0;
    label.backgroundColor = [UIColor clearColor];
    
    
    [self addSubview:label];
    
    
    [UIView animateWithDuration:0.85 delay:0.0 options:UIViewAnimationCurveEaseIn animations:^ {
        label.alpha = 0.0; 
        label.transform = CGAffineTransformTranslate(label.transform, 0, -300);
    }completion:^(BOOL finished) {
       
            [label removeFromSuperview]; 
      
    }];
}

- (void) animateAddTileResources:(NSUInteger)withValue :(MJTile*)tile {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(tile.player.lastPlayedTile.coordinate.x*64 - 75, tile.player.lastPlayedTile.coordinate.y*64, 500, 200)];
    
    label.text =[NSString stringWithFormat:@"+%i Tiles!", withValue];
    label.textColor = [UIColor greenColor];
    label.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:90.0];
    label.alpha = 1.0;
    label.backgroundColor = [UIColor clearColor];
    
    [self addSubview:label];
    
    
    [UIView animateWithDuration:0.85 delay:0.0 options:UIViewAnimationCurveEaseIn animations:^ {
        label.alpha = 0.0; 
        label.transform = CGAffineTransformTranslate(label.transform, 0, -300);
    }completion:^(BOOL finished) {
        
        [label removeFromSuperview]; 
        
    }];
    
}

- (void) animateBombResources:(NSUInteger)withValue :(MJTile*)tile {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(tile.player.lastPlayedTile.coordinate.x*64 - 100, tile.player.lastPlayedTile.coordinate.y*64, 500, 200)];
    
    label.text =[NSString stringWithFormat:@"Bomb Added!"];
    label.textColor = [UIColor blueColor];
    label.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:90.0];
    label.alpha = 1.0;
    label.backgroundColor = [UIColor clearColor];
    
    [self addSubview:label];
    
    
    [UIView animateWithDuration:0.85 delay:0.0 options:UIViewAnimationCurveEaseIn animations:^ {
        label.alpha = 0.0; 
        label.transform = CGAffineTransformTranslate(label.transform, 0, -300);
    }completion:^(BOOL finished) {
        
        [label removeFromSuperview]; 
        
    }];
}

- (void) shakeTile:(MJTile *)tile {
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.4];
    [animation setRepeatCount:25];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([tile center].x - 20.0f, [tile center].y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([tile center].x + 20.0f, [tile center].y)]];
    [animation setSpeed:50];
    [[tile layer] addAnimation:animation forKey:@"position"];
    
    
}

- (void) bombAnimationWith:(MJTile *)tile {

    
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
//    [animation setDuration:0.4];
//    [animation setRepeatCount:25];
//    [animation setAutoreverses:YES];
//    [animation setFromValue:[NSValue valueWithCGPoint:
//                             CGPointMake([tile center].x - 20.0f, [tile center].y)]];
//    [animation setToValue:[NSValue valueWithCGPoint:
//                           CGPointMake([tile center].x + 20.0f, [tile center].y)]];
//    [animation setSpeed:50];
//    [[tile layer] addAnimation:animation forKey:@"position"];
    
    UIImageView *tileUL = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_Tile_TileSize.png", tile.player.imageColor]]];
    UIImageView *tileUC = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_Tile_TileSize.png", tile.player.imageColor]]];
    UIImageView *tileUR = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_Tile_TileSize.png", tile.player.imageColor]]];
    UIImageView *tileLL = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_Tile_TileSize.png", tile.player.imageColor]]];
    UIImageView *tileLC = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_Tile_TileSize.png", tile.player.imageColor]]];
    UIImageView *tileLR = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_Tile_TileSize.png", tile.player.imageColor]]];
    UIImageView *tileL = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_Tile_TileSize.png", tile.player.imageColor]]];
    UIImageView *tileR = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_Tile_TileSize.png", tile.player.imageColor]]];
//    [tileUL setFrame:CGRectMake((tile.coordinate.x*64) - 64, (tile.coordinate.y*64) - 64, tile.frame.size.width, tile.frame.size.height)];
//    [tileUC setFrame:CGRectMake((tile.coordinate.x*64), (tile.coordinate.y*64) - 64, tile.frame.size.width, tile.frame.size.height)];
//    [tileLL setFrame:CGRectMake((tile.coordinate.x*64) - 64, (tile.coordinate.y*64) + 64, tile.frame.size.width, tile.frame.size.height)];
//    [tileUR setFrame:CGRectMake((tile.coordinate.x*64) + 64, (tile.coordinate.y*64) - 64, tile.frame.size.width, tile.frame.size.height)];
//    [tileLR setFrame:CGRectMake((tile.coordinate.x*64) + 64, (tile.coordinate.y*64) + 64, tile.frame.size.width, tile.frame.size.height)];
//    [tileLC setFrame:CGRectMake((tile.coordinate.x*64), (tile.coordinate.y*64) + 64, tile.frame.size.width, tile.frame.size.height)];
//    [tileL setFrame:CGRectMake((tile.coordinate.x*64) - 64, (tile.coordinate.y*64), tile.frame.size.width, tile.frame.size.height)];
//    [tileR setFrame:CGRectMake((tile.coordinate.x*64) + 64, (tile.coordinate.y*64), tile.frame.size.width, tile.frame.size.height)];
    [tileUL setFrame:CGRectMake((tile.coordinate.x*64), (tile.coordinate.y*64), tile.frame.size.width, tile.frame.size.height)];
    [tileUC setFrame:CGRectMake((tile.coordinate.x*64), (tile.coordinate.y*64), tile.frame.size.width, tile.frame.size.height)];
    [tileLL setFrame:CGRectMake((tile.coordinate.x*64), (tile.coordinate.y*64), tile.frame.size.width, tile.frame.size.height)];
    [tileUR setFrame:CGRectMake((tile.coordinate.x*64), (tile.coordinate.y*64), tile.frame.size.width, tile.frame.size.height)];
    [tileLR setFrame:CGRectMake((tile.coordinate.x*64), (tile.coordinate.y*64), tile.frame.size.width, tile.frame.size.height)];
    [tileLC setFrame:CGRectMake((tile.coordinate.x*64), (tile.coordinate.y*64), tile.frame.size.width, tile.frame.size.height)];
    [tileL setFrame:CGRectMake((tile.coordinate.x*64), (tile.coordinate.y*64), tile.frame.size.width, tile.frame.size.height)];
    [tileR setFrame:CGRectMake((tile.coordinate.x*64), (tile.coordinate.y*64), tile.frame.size.width, tile.frame.size.height)];
        
    tileUL.transform = CGAffineTransformMakeScale(1, 1);
    tileUC.transform = CGAffineTransformMakeScale(1, 1);
    tileUR.transform = CGAffineTransformMakeScale(1, 1);
    tileLL.transform = CGAffineTransformMakeScale(1, 1);
    tileLC.transform = CGAffineTransformMakeScale(1, 1);
    tileLR.transform = CGAffineTransformMakeScale(1, 1);
    tileL.transform = CGAffineTransformMakeScale(1, 1);
    tileR.transform = CGAffineTransformMakeScale(1, 1);
    
    
    
    CGAffineTransform newTransform;
    newTransform = CGAffineTransformMakeScale(.01f, .01f);

    [self addSubview:tileUL];
    [self addSubview:tileUC];
    [self addSubview:tileLL];
    [self addSubview:tileUR];
    [self addSubview:tileLR];
    [self addSubview:tileLC];
    [self addSubview:tileL];
    [self addSubview:tileR];
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^ {
        tile.alpha = 0.0;
        
        tileUL.transform = CGAffineTransformTranslate(newTransform, -768*30, -1024*30);
        tileLL.transform = CGAffineTransformTranslate(newTransform, -768*30, 1024*30);
        tileUR.transform = CGAffineTransformTranslate(newTransform, 768*30, -1024*30);
        tileLR.transform = CGAffineTransformTranslate(newTransform, 768*30, 1024*30);
        tileUC.transform = CGAffineTransformTranslate(newTransform, 0, (1024)*(-30));
        tileLC.transform = CGAffineTransformTranslate(newTransform, 0, (1024)*(30));
        tileL.transform = CGAffineTransformTranslate(newTransform, (768)*(-30), 0);
        tileR.transform = CGAffineTransformTranslate(newTransform, (768)*(30), 0);
        
    }completion:^(BOOL finished) {
        [tile removeFromSuperview]; 
        [tileUL removeFromSuperview];
        [tileLL removeFromSuperview];
        [tileUR removeFromSuperview];
        [tileLR removeFromSuperview];
        [tileUC removeFromSuperview];
        [tileLC removeFromSuperview];
        [tileL removeFromSuperview];
        [tileR removeFromSuperview];
    }];

}

- (void) addClusterTilesWith:(MJTile *)tile {
    
    
    
    /*for (MJTile* tile in tile.player.playedPieces) {
        if (tile.player == player) {
            //do
            MJTile* tmpTile = [[MJTile alloc] initWithCoordinate:CGPointMake(tile.coordinate.x+1, tile.coordinate.y+1)];
            //[_viewController addTile:tmpTile];
            NSLog(@"Frame from tile: %@", NSStringFromCGRect(tile.frame));
            NSLog(@"Frame from tmptTile: %@", NSStringFromCGRect(tmpTile.frame));
            
            NSLog(@"Frame from tmpTile after snapToPoint: %@", NSStringFromCGRect(tmpTile.frame));
            
            [self addClusterTilesToTerritoryWith:tmpTile];
            return;
            
        }
    }*/

//    MJTile* tmpTile1 = [[MJTile alloc] initWithCoordinate:CGPointMake(tile.coordinate.x+1, tile.coordinate.y)];
//    UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_Tile_TileSize.png", tile.player.imageColor]];
//    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
//    [imageView setFrame:tmpTile1.bounds];
//    [tmpTile1 addSubview:imageView];
//    [self addClusterTilesToTerritoryWith:tmpTile1];
//    
//    MJTile* tmpTile2 = [[MJTile alloc] initWithCoordinate:CGPointMake(tile.coordinate.x, tile.coordinate.y+1)];
//    UIImage* image2 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_Tile_TileSize.png", tile.player.imageColor]];
//    UIImageView* imageView2 = [[UIImageView alloc] initWithImage:image2];
//    [imageView2 setFrame:tmpTile2.bounds];
//    [tmpTile2 addSubview:imageView2];
//    [self addClusterTilesToTerritoryWith:tmpTile2];
//    
//    MJTile* tmpTile3 = [[MJTile alloc] initWithCoordinate:CGPointMake(tile.coordinate.x-1, tile.coordinate.y)];
//    UIImage* image3 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_Tile_TileSize.png", tile.player.imageColor]];
//    UIImageView* imageView3 = [[UIImageView alloc] initWithImage:image3];
//    [imageView3 setFrame:tmpTile3.bounds];
//    [tmpTile3 addSubview:imageView3];
//    [self addClusterTilesToTerritoryWith:tmpTile3];
//    
//    MJTile* tmpTile4 = [[MJTile alloc] initWithCoordinate:CGPointMake(tile.coordinate.x, tile.coordinate.y-1)];
//    UIImage* image4 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_Tile_TileSize.png", tile.player.imageColor]];
//    UIImageView* imageView4 = [[UIImageView alloc] initWithImage:image4];
//    [imageView4 setFrame:tmpTile4.bounds];
//    [tmpTile4 addSubview:imageView4];
//    [self addClusterTilesToTerritoryWith:tmpTile4];
    
}

- (void) addClusterTilesToTerritoryWith:(MJTile *)tile {
	
//	// Check if tile is placed ontop of one of your own tiles
//	MJTile* tileCollision = [self tileAtCoordinate:tile.coordinate];
//	if (tile.player == tileCollision.player) {
//		NSLog(@"Cluster Tile generated ontop of own piece, need new coordinate");
//        
//		return;
//	}
//	
//	// Check if tile is placed ontop of another player's tile
//	else if (tileCollision && tile.player != tileCollision.player) {
//
//        NSLog(@"Collision with %@'s tile", tileCollision.player.handle);
//
//		return;
//	}
//	
//	BOOL isTileConnected = [self isTileConnectedTo:tile];
//	
//    
//	if (!isTileConnected) {
//        [tile touchesCancelled:nil withEvent:nil];
//        [tile.toolbar animateInventoryCounter];
//	}
//	else {

        //Set the appropriate tile flags
		[tile setIsPlayed:YES];
		[tile setUserInteractionEnabled:NO];
		tile.tag=1;

        
		//Add it to the board (container view)
        //[self addSubview:tile];
		[_containerView addSubview:tile];
		
		//Add tile to the current player
		MJPlayer* player = _viewController.currentPlayer;
		[player setLastPlayedTile:tile];
		[tile setPlayer:player];
		[player.playedPieces addObject:tile];
        NSLog(@"Print of player.playedPieces array: %@", player.playedPieces);
		[_pieces addObject:tile];
        NSLog(@"Print of _pieces array:%@", _pieces);
        didRecieveResource = NO;
		
//		id resourceCollision = [self resourceAtCoordinate:tile.coordinate];
//        
//		if ([resourceCollision isMemberOfClass:[MJResource class]]) {
//			MJResource *tmpResource = [self resourceAtCoordinate:tile.coordinate];
//            tile.player.score += tmpResource.value;
//			NSLog(@"%@ found a resource worth %i bananas!", tile.player.handle, tmpResource.value);
//            [self animatePositivePointResources:tmpResource.value:tile.coordinate];
//            didRecieveResource = YES;
//            [player updateScore];
//		}
//        
//        if ([resourceCollision isMemberOfClass:[MJAddTilesResource class]]) {
//            MJResource *tmpResource = [self resourceAtCoordinate:tile.coordinate];
//            NSLog(@"%@ found an AddTile resource worth %i tiles!", tile.player.handle, [(MJAddTilesResource*)tmpResource tilesGenerated]);
//            [tile.player updateNumberOfTilesToPlayWithNumber:[(MJAddTilesResource*)tmpResource tilesGenerated]];
//            [tile.toolbar animateInventoryCounter];
//            [self animateAddTileResources:[(MJAddTilesResource*)tmpResource tilesGenerated]:tile.coordinate];
//        }
//        
//        if ([resourceCollision isMemberOfClass:[MJBombResource class]]) {
//            MJBombResource *tmpResource = (MJBombResource*)[self resourceAtCoordinate:tile.coordinate];
//            NSLog(@"%@ found an Bomb resource worth %i bombs!", tile.player.handle, tmpResource.bombs);
//            [tile.player updateNumberOfBombsToPlayWithNumber:tmpResource.bombs];
//            didRecieveResource = YES;
//            [self animateBombResources:1 :tile.coordinate];
//            //MJBombTile *tmpBombTile = [[MJBombTile alloc] init];
//            //[tile.player.toolBarPieces addObject:tmpBombTile];
//            [tile.toolbar addBombToToolBar:tile.player];
//            [tile.toolbar animateBombCounter];
//        }
//        
//        if ([resourceCollision isMemberOfClass:[MJClusterResource class]]) {
//            MJClusterResource *tmpResource = (MJClusterResource*)[self resourceAtCoordinate:tile.coordinate];
//            NSLog(@"%@ found a cluster resource worth %i tiles!", tile.player.handle, [(MJClusterResource*)tmpResource generateTiles]);
//            [self addClusterTilesFor:tile.player];
//            
//        }
//        
//        if ([resourceCollision isMemberOfClass:[MJNegativeResource class]]) {
//            MJNegativeResource *tmpResource = (MJNegativeResource*)[self resourceAtCoordinate:tile.coordinate];
//            NSLog(@"%@ aww found a negative resource worth %i points", tile.player.handle, tmpResource.value);
//            [self animateNegativePointResources:tmpResource.value :tile.coordinate];
//            didRecieveResource = YES;
//            [player updateScore];
//        }
	//}
}

@end
