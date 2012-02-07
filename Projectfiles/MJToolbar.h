//
//  MJToolbar.h
//  MAKJAM
//
//  Created by Andrew Huss on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJPieceImageView.h"

@class MJPieceImageView;

@interface MJToolbar : UIScrollView <UIScrollViewDelegate> {
	CGFloat maxX;
	CGFloat offset;
	NSMutableArray* pieces;
}

@property (nonatomic) CGFloat toolbarHeight;
@property (strong, nonatomic) NSMutableArray* pieces;

- (void) createDebugPieces;
- (void) addPiece:(MJPieceImageView*)piece;
- (void) removePiece:(MJPieceImageView*)piece;
- (void) reloadToolbarStartingAtIndex:(NSUInteger)index;

@end
