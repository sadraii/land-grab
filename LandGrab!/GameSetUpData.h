//
//  GameSetUpData.h
//  LandGrab!
//
//  Created by Helen Saenz on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameSetUpData : NSObject

@property (readwrite, nonatomic)    NSUInteger      numberOfPlayers;
@property (strong, nonatomic)       NSMutableArray  *playerNames;
@property (strong, nonatomic)       NSString        *gameType;
@property (readwrite, nonatomic)    NSUInteger      numberOfMinutes;
@property (readwrite, nonatomic)    NSUInteger      numberOfTurns;
@property (readwrite, nonatomic)    CGSize          boardSize;

-(void)printData;

@end
