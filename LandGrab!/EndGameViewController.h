//
//  EndGameViewController.h
//  LandGrab!
//
//  Created by Helen Saenz on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EndGameData;

@interface EndGameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel        *PlayerWinLabel;
@property (weak, nonatomic) IBOutlet UILabel        *Player1Score;
@property (weak, nonatomic) IBOutlet UILabel        *Player2Score;
@property (weak, nonatomic) IBOutlet UILabel        *Player3Score;
@property (weak, nonatomic) IBOutlet UILabel        *Player4Score;
@property (strong, nonatomic)        EndGameData    *endGameData;
@property (strong, nonatomic)        NSMutableArray *players;
@property (readwrite, nonatomic)    NSUInteger       numberOfPlayers;

-(void)calculateEndGame;

@end
