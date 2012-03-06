//
//  MainMenu.h
//  LandGrab!
//
//  Created by Helen Saenz on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMenu : UIViewController

@property (assign, nonatomic) int numberOfPlayers;


-(IBAction)tappedNewGame:(id)sender;
-(IBAction)tappedTwoPlayers:(id)sender;
-(IBAction)tappedThreePlayers:(id)sender;
-(IBAction)tappedFourPlayers:(id)sender;
-(IBAction)tappedTimeBased:(id)sender;
-(IBAction)tappedTurnBased:(id)sender;
-(IBAction)tappedUnlimtedBased:(id)sender;
-(IBAction)tappedTwoMinutes:(id)sender;
-(IBAction)tappedFiveMinutes:(id)sender;
-(IBAction)tappedTenMinutes:(id)sender;
-(IBAction)tappedTwentyTurns:(id)sender;
-(IBAction)tappedFiftyTurns:(id)sender;
-(IBAction)tappedHundredTurns:(id)sender;


@end
