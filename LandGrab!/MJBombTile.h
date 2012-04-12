//
//  MJBombTile.h
//  LandGrab!
//
//  Created by student on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJTile.h"
#import "MJTile.h"
#import "MJPlayer.h"
#import "MJToolbar.h"
#import "MJViewController.h"
#import "MJBoard.h"
#import "MJInventoryCount.h"

@interface MJBombTile : MJTile 
    

@property (strong, nonatomic) id <MJTileDelegate> delegate;

@property (weak, nonatomic) MJViewController * viewController;
@property (weak, nonatomic) MJBoard* board;
@property (weak, nonatomic) MJToolbar* toolbar;

@property (weak, nonatomic) MJPlayer* player;

@property (readwrite, nonatomic) CGPoint currentPoint;

@end
