//
//  MJContainerView.h
//  LandGrab!
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJBoard;

@interface MJContainerView : UIView

@property (strong, nonatomic) UIImageView* iv;
@property (weak, nonatomic) MJBoard* board;

@end
