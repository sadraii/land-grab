//
//  MJTile.h
//  MAKJAM
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJTileDelegate.h"

@class MJPiece;

const NSUInteger TILE_SIZE = 64;

@interface MJTile : UIView {
@public
	CGPoint coordinate;
	CGRect frame;
@private
	CGPoint currentPoint;
	CGSize distanceTraveled;
}

@property (strong, nonatomic) id <MJTileDelegate> delegate;
@property (weak, nonatomic) MJPiece* piece;
@property (readwrite) CGPoint coordinate;
@property (readwrite) CGRect frame;

- (id) initWithCoordinate:(CGPoint)aCoordinate;
- (CGPoint) centerFromPoint:(CGPoint)point;


@end
