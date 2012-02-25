//
//  MJViewController.h
//  LandGrab!
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJToolbar;
@class MJBoard;
@class MJPlayer;
@class MJPiece;

@interface MJViewController : UIViewController {
	NSInteger currentPlayer;
}

@property (strong, nonatomic) IBOutlet UIView* topbar;
@property (strong, nonatomic) IBOutlet UILabel* score;
@property (strong, nonatomic) IBOutlet UILabel* handle;
@property (strong, nonatomic) IBOutlet UILabel* territory;

@property (strong, nonatomic) IBOutlet MJBoard* board;
@property (strong, nonatomic) IBOutlet MJToolbar* toolbar;


@end
