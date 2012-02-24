//
//  MJPieceDelegate.h
//  MAKJAM
//
//  Created by Andrew Huss on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MJPiece;

@protocol MJPieceDelegate <NSObject>
@required
- (BOOL) addPiece:(MJPiece*)piece;
- (BOOL) removePiece:(MJPiece*)piece;
@optional
- (BOOL) snapToPoint;
@end
