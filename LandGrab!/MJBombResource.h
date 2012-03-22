//
//  MJBombResource.h
//  LandGrab!
//
//  Created by Helen Saenz on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJResource.h"

@interface MJBombResource : MJResource

@property (readwrite, nonatomic) NSUInteger bombs;

- (NSUInteger) generateBombs;

@end
