//
//  MJTileDelegate.h
//  MAKJAM
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MJTile;

@protocol MJTileDelegate <NSObject>
@required
- (void) touchesBegan:(CGPoint)point;
- (void) touchesMoved:(CGSize)distance;
- (void) touchesEnded:(CGPoint)point;
- (void) touchesCanceled: (CGSize)distanceTraveled;

@end
