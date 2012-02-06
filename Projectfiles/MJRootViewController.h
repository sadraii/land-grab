//
//  MJRootViewController.h
//  MAKJAM
//
//  Created by Andrew Huss on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KKRootViewController.h"
#import "MJToolbar.h"

@interface MJRootViewController : KKRootViewController

@property (strong, nonatomic) EAGLView* eaglView;
@property (strong, nonatomic) MJToolbar* scrollView;

@end
