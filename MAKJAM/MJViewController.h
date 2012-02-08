//
//  MJViewController.h
//  MAKJAM
//
//  Created by Andrew Huss on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJPieceDelegate.h"

@class MJPiece;
@class MJToolbar;
@class MJBoard;

@interface MJViewController : UIViewController <MJPieceDelegate>

@property (strong, nonatomic) IBOutlet MJToolbar* toolbar;
@property (strong, nonatomic) IBOutlet MJBoard* board;

- (void) createDebugPieces;

@end
