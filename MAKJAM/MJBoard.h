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

@interface MJBoard : UIScrollView <MJPieceDelegate> {
	NSUInteger unitLength;
}

- (void) clearBoard;
-(CGPoint) snapPieceToPoint:(MJPiece*)piece;

@end
