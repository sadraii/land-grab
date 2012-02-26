//
//  MJTileDelegate.h
//  LandGrab!
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MJTileDelegate <NSObject>
@required
- (void) touchesBegan:(UITouch*)touch;
- (void) touchesMoved:(CGSize)distance;
- (void) touchesEnded:(UITouch*)touch;
- (void) touchesCanceled: (CGSize)distanceTraveled;
@end
