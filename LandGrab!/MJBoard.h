//
//  MJBoard.h
//  LandGrab!
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJViewController;
@class MJContainerView;
@class MJBoard;
@class MJPlayer;
@class MJTile;
@class MJResource;
@class MJBombTile;

@interface MJBoard : UIScrollView <UIScrollViewDelegate>
{
    CGSize boardSize;//Size relative to tilesize
    BOOL didRecieveResource;
}

@property (weak, nonatomic) IBOutlet MJViewController* viewController;

@property (strong, nonatomic) NSMutableArray* pieces;
@property (strong, nonatomic) NSMutableArray* resources;

@property (readonly)CGSize boardSize;
@property (strong, nonatomic) MJContainerView* containerView;

+ (NSUInteger) tileSize;

- (void) newGame;
- (void) setBoardSize:(CGSize)size;

- (MJTile*) tileAtCoordinate:(CGPoint)coordinate;
- (MJResource*) resourceAtCoordinate:(CGPoint)coordinate;
- (BOOL) resourcesAroundCoordinate:(CGPoint)coordinate;

- (BOOL) isCoordinateOnBoard:(CGPoint)coordinate;
- (void) updateZoomScale;
- (void) zoomOutAnimated:(BOOL)animated;

- (void) addTile:(MJTile*)tile;
- (void) addResource:(MJResource*)resource;

- (BOOL) isTileConnectedTo:(MJTile*)tile;

- (void)addBombTile:(MJBombTile*)tile;



- (void) animatePositivePointResources:(NSUInteger)withValue:(CGPoint)tileCoordinates;
- (void) animateNegativePointResources:(NSUInteger)withValue:(CGPoint)tileCoordinates;
- (void) animateAddTileResources:(NSUInteger)withValue:(CGPoint)tileCoordinates;
- (void) animateBombResources:(NSUInteger)withValue:(CGPoint)tileCoordinates;
- (void) animateClusterResources:(NSUInteger)withValue:(CGPoint)tileCoordinates;

@end
