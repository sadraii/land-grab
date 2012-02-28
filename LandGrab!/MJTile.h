//
//  MJTile.h
//  LandGrab!
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJTileDelegate.h"

@class MJPiece;
@class MJPlayer;
@class MJBoard;
@class MJToolbar;
@class MJViewController;

@interface MJTile : UIView {
@private
	CGSize distanceFromOrigin;
	CGSize distanceTraveled;
	UIView* startingView;
	CGPoint startingOrigin;
}

@property (strong, nonatomic) id <MJTileDelegate> delegate;

@property (weak, nonatomic) MJViewController * viewController;
@property (weak, nonatomic) MJBoard* board;
@property (weak, nonatomic) MJToolbar* toolbar;

@property (weak, nonatomic) MJPlayer* player;
@property (weak, nonatomic) MJPiece* piece;

@property (readwrite, nonatomic) CGPoint coordinate;
@property (readwrite, nonatomic) CGPoint currentPoint;
@property (readwrite, nonatomic) BOOL isPlayed;

- (id) initWithCoordinate:(CGPoint)aCoordinate;
- (CGSize) distanceFromOrigin:(CGPoint)point;
- (void) moveDistance:(CGSize) distance;
- (void) updateCoordinate;
- (void) snapToPoint;
@end
