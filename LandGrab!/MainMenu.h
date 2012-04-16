//
//  MainMenu.h
//  LandGrab!
//
//  Created by Helen Saenz on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GameSetUpData;
@class MJViewController;

@interface MainMenu : UIViewController

@property (strong, nonatomic)       GameSetUpData       *gameSetUp;
@property (strong, nonatomic)       MJViewController    *mjViewController;
@property (readwrite, nonatomic)    BOOL                 isViewControllerSetUp;
@property (readwrite, nonatomic)    int                  counter;
@property (weak, nonatomic) IBOutlet UIButton *startNewGame;

@property (weak, nonatomic) IBOutlet UIButton *twoPlayersButton;
@property (weak, nonatomic) IBOutlet UIButton *threePlayersButton;
@property (weak, nonatomic) IBOutlet UIButton *fourPlayersButton;
@property (weak, nonatomic) IBOutlet UIButton *timeBasedButton;
@property (weak, nonatomic) IBOutlet UIButton *turnBasedButton;
@property (weak, nonatomic) IBOutlet UIButton *twoMinutesButton;
@property (weak, nonatomic) IBOutlet UIButton *fiveMinutesButton;
@property (weak, nonatomic) IBOutlet UIButton *tenMinutesButton;
@property (weak, nonatomic) IBOutlet UIButton *twentyTurnsButton;
@property (weak, nonatomic) IBOutlet UIButton *fiftyTurnsButton;
@property (weak, nonatomic) IBOutlet UIButton *hundredTurnsButton;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *boardsize20x20;
@property (weak, nonatomic) IBOutlet UIButton *boardsize30x30;
@property (weak, nonatomic) IBOutlet UIButton *boardsize50x50;

//-(IBAction)tappedNewGame:(id)sender;
-(IBAction)tappedHowManyPlayers:(UIButton *)button;
-(IBAction)tappedTypeOfGame:(UIButton *)button;
-(IBAction)tappedboardsize:(UIButton *)button;



-(void)setBoolCorrectly;

@end
