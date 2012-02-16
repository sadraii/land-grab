//
//  MJBoard.h
//  MAKJAM
//
//  Created by Andrew Huss on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJPieceDelegate.h"
#import "MJPiece.h"

@interface MJBoard : UIScrollView <MJPieceDelegate, UIScrollViewDelegate> {
	CGSize boardSize;
	NSUInteger unitLength;
	id table;
}

@property (strong, nonatomic) NSMutableArray* pieces;
@property (strong, nonatomic) UIView* containerView;

- (void) clearBoard;
- (void) setBoardSize:(CGSize)size;
- (CGPoint) snapPieceToPoint:(MJPiece*)piece;
- (void) scalePiece:(MJPiece*)piece;
- (CGPoint) originOfPiece:(MJPiece*)piece;

@end
