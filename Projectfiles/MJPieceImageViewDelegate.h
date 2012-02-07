//
//  MJPieceImageViewDelegate.h
//  MAKJAM
//
//  Created by Andrew Huss on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MJPieceImageView;

@protocol MJPieceImageViewDelegate <NSObject>
@required
- (BOOL) handleDroppedPiece:(MJPieceImageView*)piece;

@end
