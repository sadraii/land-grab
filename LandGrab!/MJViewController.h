//
//  MJViewController.h
//  LandGrab!
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJTopBar;
@class MJBoard;
@class MJToolbar;
@class MJPlayer;
@class MJTile;
@class MainMenu;
@class GameSetUpData;

@interface MJViewController : UIViewController {
	NSInteger currentPlayerIndex;
	NSUInteger turnCount;
}
@property (strong, nonatomic)   IBOutlet    MJTopBar        *topbar;
@property (strong, nonatomic)   IBOutlet    UILabel         *handle;
@property (strong, nonatomic)   IBOutlet    UILabel         *territory;
@property (strong, nonatomic)   IBOutlet    UILabel         *score;

@property (strong, nonatomic)   IBOutlet    MJBoard         *board;

@property (strong, nonatomic)   IBOutlet    MJToolbar       *toolbar;
@property (strong, nonatomic)   IBOutlet    UIStepper       *zoomStepper;

@property (strong, nonatomic)               NSMutableArray  *players;
@property (weak, nonatomic)                 MJPlayer        *currentPlayer;
@property (readwrite, nonatomic)            BOOL             isInitalLaunch;

@property (strong, nonatomic)   IBOutlet    MainMenu        *mainMenuViewController;
@property (readwrite, nonatomic)            NSUInteger       numberOfPlayers;
@property (weak, nonatomic)               GameSetUpData   *gameSetUpData;

- (IBAction)newGame:(id)sender;
- (IBAction)zoom:(id)sender;
- (void) createPlayers;
- (void) createResources;
- (void) nextPlayer;
- (void) addTile:(MJTile*)tile;
//- (void) updateScore;

@end
