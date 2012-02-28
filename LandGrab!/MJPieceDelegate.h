//
//  MJPieceDelegate.h
//  LandGrab!
//
//  Created by Andrew Huss on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MJPiece;

@protocol MJPieceDelegate <NSObject>
@required
- (void) addPiece:(id)piece;
- (void) removePiece:(id)piece;
@end
