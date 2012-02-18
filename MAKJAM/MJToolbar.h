//
//  MJToolbar.h
//  MAKJAM
//
//  Created by Andrew Huss on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJPieceDelegate.h"

@class MJPiece;
@class MJViewController;
@class MJPlayer;

@interface MJToolbar : UIScrollView <UIScrollViewDelegate, MJPieceDelegate> {
	CGFloat maxX;
	CGFloat offset;
	NSMutableArray* pieces;
	CGFloat scale;
	CGFloat pieceHeight;
}

@property (weak, nonatomic) MJViewController* parentViewController;

@property (nonatomic) BOOL offset;
//@property (nonatomic) CGFloat toolbarHeight;
@property (strong, nonatomic) NSMutableArray* pieces;

- (void) newGame;
- (void) scalePiece:(MJPiece*)piece;
- (void) reloadToolbarStartingAtIndex:(NSUInteger)index;
- (void) loadPlayersPieces:(MJPlayer*)player;
- (void) clear;

@end
