//
//  MJBoard.h
//  LandGrab!
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJPieceDelegate.h"

@class MJViewController;
@class MJPiece;
@class MJContainerView;
@class MJBoard;
@class MJPlayer;
@class MJTile;

@interface MJBoard : UIScrollView <UIScrollViewDelegate, MJPieceDelegate>
{
    CGSize boardSize;//Size relative to tilesize
}

@property (weak, nonatomic) IBOutlet MJViewController* viewController;
@property (strong, nonatomic) NSMutableArray* pieces;
@property (readonly)CGSize boardSize;
@property (strong, nonatomic) MJContainerView* containerView;

- (void) newGame;
- (void) setBoardSize:(CGSize)size;
- (MJTile*) tileAtCoordinate:(CGPoint)coordinate;
- (BOOL) isCoordinateOnBoard:(CGPoint)coordinate;
@end
