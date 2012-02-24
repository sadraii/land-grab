//
//  MJViewController.h
//  MAKJAM
//
//  Created by Andrew Huss on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJPieceDelegate.h"
//#import "GCHelper.h"

@class MJPiece;
@class MJToolbar;
@class MJBoard;
@class MJPlayer;

@interface MJViewController : UIViewController <MJPieceDelegate> {// , GCHelperDelegate> {
//	uint32_t ourRandom;
//	BOOL receivedRandom;
//	NSString *otherPlayerID;
//	BOOL isPlayer1;
//	GameState gameState;
	NSInteger currentPlayer;
}

@property (weak, nonatomic) IBOutlet UILabel *volume;
@property (strong, nonatomic) IBOutlet MJToolbar* toolbar;
@property (strong, nonatomic) IBOutlet MJBoard* board;


@property (strong, nonatomic) IBOutlet UIView *topToolbar;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;


@property (strong, nonatomic) IBOutlet UIButton* rotateButton;
@property (strong, nonatomic) NSMutableArray* players;

- (IBAction)resetButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;
- (void) newGame;
- (void) nextPlayer;
- (void) addPlayer;
//- (void) loadPieces;

@end
