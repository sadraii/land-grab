//
//  MJPlayer.h
//  LandGrab!
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MJViewController;
@class MJBoard;
@class MJToolbar;
@class MJTile;


@interface MJPlayer : NSObject {
}

@property (weak, nonatomic)         MJViewController*   viewController;
@property (weak, nonatomic)         MJBoard*            board;
@property (weak, nonatomic)         MJToolbar*          toolbar;

@property (strong, nonatomic)       NSMutableArray*     pieces;
@property (strong, nonatomic)       NSMutableArray*     playedPieces;
@property (strong, nonatomic)       NSMutableArray*     toolBarPieces;
@property (weak, nonatomic)         MJTile*             lastPlayedTile;

@property (strong, nonatomic)       NSString*           handle;
@property (strong, nonatomic)       UIColor*            color;
@property (strong, nonatomic)       NSString*           imageColor;
@property (strong, nonatomic)       MJTile*             capital;
@property (readwrite, nonatomic)    NSInteger          score;
@property (readwrite, nonatomic)    NSUInteger          territory;
@property (readwrite, nonatomic)    NSUInteger          money;
@property (readwrite, nonatomic)    NSUInteger          combinedScore;
@property (readwrite, nonatomic)    NSUInteger          numberOfTilesToPlay;
@property (readwrite, nonatomic)    NSUInteger          numberOfBombsToPlay;


- (void) updateScore;
- (void) updateTerritory;
- (void) updateTerritoryStartingAtCoordinate:(CGPoint)point;
- (BOOL) coordinate:(CGPoint)a TouchesCoordinate:(CGPoint)b;
- (void) updateNumberOfTilesToPlayWithNumber:(NSUInteger)number;
- (void) subtractTile;
- (void) updateNumberOfBombsToPlayWithNumber:(NSUInteger)number;
- (void) subtractBomb;
@end
