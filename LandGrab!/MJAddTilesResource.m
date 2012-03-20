//
//  MJAddTilesResource.m
//  LandGrab!
//
//  Created by Helen Saenz on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJAddTilesResource.h"

@implementation MJAddTilesResource

@synthesize tilesGenerated = _tilesGenerated;

-(NSUInteger)generateTiles {
    
    //return minimum of 1 extra resource, avoids giving 0 resources
    NSInteger temp = arc4random_uniform(5);
    if (temp == 0) {
        return _tilesGenerated = 1;
    }
    return _tilesGenerated = temp;
    
}

@end
