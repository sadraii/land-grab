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
}

@property (strong, nonatomic) id <MJPieceDelegate> delegate;
@property (weak, nonatomic) MJViewController* parentViewController;
@property (weak, nonatomic) MJBoard* board;
@property (weak, nonatomic) MJToolbar* toolbar;

- (CGPoint) centerFromPoint:(CGPoint)point;
@end
