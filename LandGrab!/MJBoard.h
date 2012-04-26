//
//  MJBoard.h
//  LandGrab!
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

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
    SystemSoundID _posResourceSound;
    SystemSoundID _negResourceSound;
    SystemSoundID _bombSound;
    SystemSoundID _addTileSound;
    SystemSoundID _getBombSound;
    SystemSoundID _clusterSound;
}

@property (weak, nonatomic) IBOutlet    MJViewController*   viewController;

@property (strong, nonatomic)           NSMutableArray*     pieces;
@property (strong, nonatomic)           NSMutableArray*     resources;

@property (readonly)                    CGSize              boardSize;
@property (strong, nonatomic)           MJContainerView*    containerView;

@property (strong, nonatomic)           MJTile*             tileToRemove;

+ (NSUInteger) tileSize;

- (void) newGame;
- (void) setBoardSize:(CGSize)size;

- (MJTile*) tileAtCoordinate:(CGPoint)coordinate;
- (void) removeTileAtCoordinate:(CGPoint)coordinate;
- (MJBombTile*) bombAtCoordinate:(CGPoint)coordinate;
- (MJResource*) resourceAtCoordinate:(CGPoint)coordinate;
- (BOOL) resourcesAroundCoordinate:(CGPoint)coordinate;

- (BOOL) isCoordinateOnBoard:(CGPoint)coordinate;
- (void) updateZoomScale;
- (void) zoomOutAnimated:(BOOL)animated;

- (void) addTile:(MJTile*)tile;
- (void) addResource:(MJResource*)resource;

- (BOOL) isTileConnectedTo:(MJTile*)tile;

- (void)addBombTile:(MJBombTile*)tile;



- (void) animatePositivePointResources:(NSUInteger)withValue:(MJTile*)tile;
- (void) animateNegativePointResources:(NSUInteger)withValue:(MJTile*)tile;
- (void) animateAddTileResources:(NSUInteger)withValue:(MJTile*)tile;
- (void) animateBombResources:(NSUInteger)withValue:(MJTile*)tile;
- (void) animateClusterResources:(NSUInteger)withValue:(MJTile*)tile;

- (void) bombAnimationWith:(MJTile*)tile;

- (void) shakeTile:(MJTile*)tile;

- (void) addClusterTilesWith:(MJTile*)tile;
- (void) addClusterTilesToTerritoryWith:(MJTile*)tile;


@end
