//
//  MJViewController.h
//  LandGrab!
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class MJTopBar;
@class MJBoard;
@class MJToolbar;
@class MJPlayer;
@class MJTile;
@class MainMenu;
@class GameSetUpData;
@class EndGameData;
@class EndGameViewController;
@class MJClockWidget;

@interface MJViewController : UIViewController <AVAudioPlayerDelegate> {
	NSInteger currentPlayerIndex;
	NSUInteger turnCount;
    BOOL _backgroundMusicPlaying;
	BOOL _backgroundMusicInterrupted;
	UInt32 _otherMusicIsPlaying;
    float angle;
}
@property (strong, nonatomic)   IBOutlet    MJTopBar                *topbar;
@property (strong, nonatomic)   IBOutlet    UILabel                 *handle;
@property (strong, nonatomic)   IBOutlet    UILabel                 *territory;
@property (strong, nonatomic)   IBOutlet    UILabel                 *score;

@property (strong, nonatomic)   IBOutlet    MJBoard                 *board;

@property (strong, nonatomic)   IBOutlet    MJToolbar               *toolbar;
@property (strong, nonatomic)   IBOutlet    UIStepper               *zoomStepper;

@property (strong, nonatomic)               NSMutableArray          *players;
@property (weak, nonatomic)                 MJPlayer                *currentPlayer;
@property (readwrite, nonatomic)            BOOL                     isInitalLaunch;

@property (strong, nonatomic)   IBOutlet    MainMenu                *mainMenuViewController;
@property (readwrite, nonatomic)            NSUInteger               numberOfPlayers;
@property (weak, nonatomic)                 GameSetUpData           *gameSetUpData;
@property (weak, nonatomic) IBOutlet        UILabel                 *gameTypeLabel;
@property (weak, nonatomic) IBOutlet        UILabel                 *gameTypeLabelCounter;
@property (readwrite, nonatomic)            NSUInteger               secondsLeft;
@property (strong, nonatomic)               NSTimer                 *clockForTimeBasedGame;

@property (weak, nonatomic)               EndGameViewController   *endGameViewController;
@property (strong, nonatomic)               EndGameData             *endGameData;
@property (readwrite, nonatomic)            NSUInteger               roundCount;
@property (readwrite, nonatomic)            NSInteger               resourcePoints;

@property (strong, nonatomic)               AVAudioPlayer           *backgroundMusicPlayer;
@property (strong, nonatomic)               UIImageView             *bigResource;

//@property (strong, nonatomic)               MJClockWidget           *clock;

- (IBAction)newGame:(id)sender;
- (IBAction)zoom:(id)sender;
- (void) createPlayers;
- (void) createResources;
- (void) nextPlayer;
- (void) addTile:(MJTile*)tile;
- (void) setUpTimeBasedGame;
- (void) createTimeBasedGameTimer;
- (void) createTurnBasedGameCounter;
- (void) setUpTurnBasedGame;
- (void) updateTurnCount;
- (void) endSequence;
- (void) tryPlayMusic;

- (void) animateBigResource;
//- (void) updateScore;

@end
