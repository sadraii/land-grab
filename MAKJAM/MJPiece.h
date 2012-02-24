//
//  MJPiece.h
//  MAKJAM
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

@interface MJPiece : NSObject <MJTileDelegate> {
	CGPoint origin;
	CGSize size;
	NSMutableArray* tiles;
	NSInteger rotation;
	UIImage* image;
	NSString* name;
	BOOL isPlayed;//Yes:is on board No:is on toolbar
}

@property (strong, nonatomic) id <MJPieceDelegate> delegate;
@property (weak, nonatomic) MJViewController* viewController;
@property (weak, nonatomic) id superview;
@property (weak, nonatomic) MJPlayer* player;

@property (readonly) CGSize size;
@property (strong, nonatomic) NSMutableArray* tiles;
@property (readwrite) NSInteger rotation;
@property (strong, nonatomic) UIImage* image;
@property (strong, nonatomic) NSString* name;
@property (readwrite) BOOL isPlayed;

- (void) setOrigin:(CGPoint)point;
- (CGPoint) origin;
- (void) moveTiles:(CGSize)distance;
- (void) snapToPoint;
- (void) addAsSubviewToView:(UIView*)view;
- (void) removeFromSuperview;
- (void) loadDefaultTiles;
- (void) addTile:(MJTile*)tile;
- (void) revertToStartingSize;
- (void) setScale:(CGFloat)scale;

@end
