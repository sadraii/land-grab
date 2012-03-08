//
//  GameSetUpData.m
//  LandGrab!
//
//  Created by Helen Saenz on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameSetUpData.h"

@implementation GameSetUpData

@synthesize numberOfPlayers = _numberOfPlayers;
@synthesize playerNames = _playerNames;
@synthesize gameType = _gameType;
@synthesize numberOfSeconds = _numberOfSeconds;
@synthesize numberOfTurns = _numberOfTurns;
@synthesize boardSize = _boardSize;

-(void)printData {
    NSLog(@"Number Of Players: %d.\n", _numberOfPlayers);
    NSLog(@"Game Type: %@.\n", _gameType);
    if ([_gameType isEqualToString:@"timeBased"]) {
        NSLog(@"Number Of Seconds: %d.\n", _numberOfSeconds);
    }
    if ([_gameType isEqualToString:@"turnBased"]) {
        NSLog(@"Number Of Turns: %d.\n", _numberOfTurns);
    }
}

@end
