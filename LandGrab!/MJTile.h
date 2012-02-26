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

@interface MJTile : UIView {
@public
CGPoint coordinate;
@private
CGPoint currentPoint;
CGSize distanceTraveled;
}

@property (strong, nonatomic) id <MJTileDelegate> delegate;
@property (weak, nonatomic) MJPiece* piece;
@property (readwrite) CGPoint coordinate;
@property (readwrite) CGPoint currentPoint;

- (id) initWithCoordinate:(CGPoint)aCoordinate;
- (CGPoint) centerFromPoint:(CGPoint)point;
- (void) moveDistance:(CGSize) distance;
- (void) updateCoordinate;
@end
