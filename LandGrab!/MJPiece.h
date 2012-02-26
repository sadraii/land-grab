//
//  MJPiece.h
//  LandGrab!
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJTileDelegate.h"
#import "MJPieceDelegate.h"

@class MJTile;
@class MJViewController;
@class MJPlayer;
@class MJBoard;
@class MJToolbar;

@interface MJPiece : NSObject <MJTileDelegate> {
@public
	CGPoint origin;
	CGSize size;
	CGPoint lastTouch;
	CGPoint coordinate;
	NSString* name;
	BOOL isPlayed;//Yes:is on board No:is on toolbar
@private
	NSMutableArray* tiles;
	UIImage* image;
	
}

@property (strong, nonatomic) id <MJPieceDelegate> delegate;
@property (weak, nonatomic) MJViewController* viewController;
@property (weak, nonatomic) MJBoard* board;
@property (weak, nonatomic) MJToolbar* toolbar;
@property (weak, nonatomic) id superview;
@property (weak, nonatomic) MJPlayer* player;
@property (readwrite, nonatomic) CGPoint origin;
@property (readwrite, nonatomic) CGPoint coordinate;
@property (readwrite, nonatomic) CGSize size;
@property (readwrite, nonatomic) CGPoint lastTouch;
@property (weak, nonatomic) MJTile* lastTouchedTile;
@property (strong, nonatomic) NSMutableArray* tiles;
@property (strong, nonatomic) UIImage* image;
@property (strong, nonatomic) NSString* name;
@property (readwrite, nonatomic) BOOL isPlayed;

- (void) setOrigin:(CGPoint)point;
- (void) moveTiles:(CGSize)distance;
- (void) snapToPoint;
- (void) addAsSubviewToView:(UIView*)view;
- (void) removeFromSuperview;

- (void) loadDebugTiles;
- (void) addTile:(MJTile*)tile;
- (void) revertToStartingSize;
- (void) setScale:(CGFloat)scale;
- (UIView*) view;

@end