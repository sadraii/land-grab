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

-(void)generateTiles {
    
    _tilesGenerated = arc4random_uniform(5);
    
}

@end
