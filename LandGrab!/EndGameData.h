//
//  EndGameData.h
//  LandGrab!
//
//  Created by Helen Saenz on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EndGameData : NSObject

@property (strong, nonatomic)       NSString        *winner;
@property (strong, nonatomic)       NSMutableArray  *players;
@property (readwrite, nonatomic)    NSUInteger       numberOfPlayers;

@end
