//
//  MJPieceImageView.h
//  MAKJAM
//
//  Created by Andrew Huss on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJPieceImageViewDelegate.h"
#import "MJToolbar.h"
@class MJToolbar;

@interface MJPieceImageView : UIImageView {
	CGPoint currentPosition;
	CGPoint startingPosition;
}

@property (strong, nonatomic) id <MJPieceImageViewDelegate> delegate;
@property (strong, nonatomic) MJToolbar* toolbar;

- (CGPoint) centerFromPoint:(CGPoint)point;
@end
