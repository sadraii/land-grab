//
//  MJAddTilesResource.h
//  LandGrab!
//
//  Created by Helen Saenz on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJResource.h"
#import "MJPlayer.h"

@interface MJAddTilesResource : MJResource

@property (readwrite, nonatomic) NSUInteger tilesGenerated;

-(NSUInteger)generateTiles;

@end
