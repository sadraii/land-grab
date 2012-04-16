//
//  MJClusterResource.h
//  LandGrab!
//
//  Created by student on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJResource.h"

@interface MJClusterResource : MJResource

@property (readwrite, nonatomic) NSUInteger tilesGenerated;

-(NSUInteger)generateTiles;

@end
