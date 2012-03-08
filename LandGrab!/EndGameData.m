//
//  EndGameData.m
//  LandGrab!
//
//  Created by Helen Saenz on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EndGameData.h"

@implementation EndGameData

@synthesize winner;
@synthesize players = _players;
@synthesize numberOfPlayers;

-(id)init {
    if(self = [super init]) {
        _players = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
