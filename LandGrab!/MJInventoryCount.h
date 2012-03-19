//
//  MJInventoryCount.h
//  LandGrab!
//
//  Created by Helen Saenz on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJInventoryCount : UIView

@property (strong, nonatomic) UILabel *counter;


-(void)updateCounterWithNumber:(NSUInteger)number;
@end
