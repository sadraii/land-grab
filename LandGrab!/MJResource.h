//
//  MJResource.h
//  LandGrab!
//
//  Created by Andrew Huss on 3/1/12.
//  Copyright (c) 2012 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJBoard;
@class MJTile;

@interface MJResource : UIView

@property (readwrite, nonatomic) CGPoint coordinate;
@property (strong, nonatomic) NSMutableArray* tiles;
@property (readwrite, nonatomic) NSUInteger value;



- (id) initWithCoordinate:(CGPoint)aCoordinate;
- (void) setTilesWithCoordinateArray:(NSArray*)coordinates;
- (void) addTile:(MJTile*)tile;
- (int) setRandomResourceValueWithValue:(int)value;

@end
