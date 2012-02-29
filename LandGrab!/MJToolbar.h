//
//  MJToolbar.h
//  LandGrab!
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJPieceDelegate.h"

@class MJPiece;
@class MJViewController;
@class MJPlayer;

@interface MJToolbar : UIScrollView <MJPieceDelegate> {
@public
	
@private
	CGFloat offset;
	CGFloat pieceHeight;
	NSUInteger maxX;
}

@property (weak, nonatomic) IBOutlet MJViewController* viewController;
@property (weak, nonatomic) MJPlayer* player;
@property (strong, nonatomic) NSMutableArray* pieces;

- (void) newGame;
- (void) snapPieceToPoint:(MJPiece*)piece;
- (void) insertPiece:(MJPiece*) piece AtIndex:(NSUInteger)index;
- (void) loadPlayer:(MJPlayer*) player;
- (void) removeAllPieces;

@end