//
//  MJClusterResource.m
//  LandGrab!
//
//  Created by student on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJClusterResource.h"

@implementation MJClusterResource

@synthesize tilesGenerated = _tilesGenerated;

-(NSUInteger)generateTiles {
    
    return _tilesGenerated = arc4random_uniform(10) + 2;
    
}

@end
