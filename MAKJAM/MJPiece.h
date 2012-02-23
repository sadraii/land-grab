//
//  MJPiece.h
//  MAKJAM
//
//  Created by Andrew Huss on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJPieceDelegate.h"
#import "MJToolbar.h"
#import "MJBoard.h"

@class MJViewController;
@class MJToolbar;
@class MJBoard;

@interface MJPiece : UIImageView {
	CGPoint currentPosition;
	CGPoint startingCenter;
	UIView* startingView;
	CGPoint distanceFromCenter;
	CGFloat scale;
	CGSize startingSize;
	NSInteger currentRotation;
    NSUInteger area;
}

@property (strong, nonatomic) id <MJPieceDelegate> delegate;
@property (weak, nonatomic) MJViewController* parentViewController;
@property (weak, nonatomic) MJPlayer* player;
@property (weak, nonatomic) MJBoard* board;
@property (weak, nonatomic) MJToolbar* toolbar;
@property (readwrite) BOOL played;
@property (nonatomic) NSUInteger area;
@property (strong, nonatomic) NSArray* transparentTiles;
@property (nonatomic) CGFloat scale;
@property (nonatomic) CGSize startingSize;

- (CGPoint) centerFromPoint:(CGPoint)point;
- (void) revertToStartingSize;
- (void) setRotateButtonHidden:(BOOL)hidden;
- (void) rotatePiece;


@end
