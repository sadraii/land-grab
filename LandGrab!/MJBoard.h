//
//  MJBoard.h
//  LandGrab!
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJPiece;
@class MJContainerView;
@class MJBoard;
@class MJPlayer;

@interface MJBoard : UIScrollView
{
    CGSize boardSize;
    NSUInteger tileSize;
}

@property (strong, nonatomic) NSMutableArray* pieces;
@property (readonly)CGSize boardSize;
@property (strong, nonatomic) MJContainerView* containerView;
@property (readonly)NSUInteger tileSize;

- (void) newGame;
- (void) setBoardSize:(CGSize)size;
- (CGPoint) snapPieceToPoint:(MJPiece*)piece;
- (void) scalePiece:(MJPiece*)piece;
- (CGPoint) originOfPiece:(MJPiece*)piece;

@end
