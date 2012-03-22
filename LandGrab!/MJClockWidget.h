//
//  MJClockWidget.h
//  LandGrab!
//
//  Created by student on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJClockWidget : UIView

@property (strong, nonatomic)NSTimer* clockTimer;
@property (nonatomic)NSInteger secondsLeft; // provided by time settings
@property (nonatomic)NSInteger increment; // used for degree incrementing

- (void) createTimer;
- (void) updateTimer;
- (void) endSequence;

@end
