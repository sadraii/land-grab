//
//  MJViewController.h
//  MAKJAM
//
//  Created by Andrew Huss on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJPieceDelegate.h"
#import "GCHelper.h"

@class MJPiece;
@class MJToolbar;
@class MJBoard;

//typedef enum {
//    kGameStateWaitingForMatch = 0,
//    kGameStateWaitingForRandomNumber,
//    kGameStateWaitingForStart,
//    kGameStateActive,
//    kGameStateDone
//} GameState;
//
//typedef enum {
//    kEndReasonWin,
//    kEndReasonLose,
//    kEndReasonDisconnect
//} EndReason;
//
//typedef enum {
//    kMessageTypeRandomNumber = 0,
//    kMessageTypeGameBegin,
//    kMessageTypeMove,
//    kMessageTypeGameOver
//} MessageType;
//
//typedef struct {
//    MessageType messageType;
//} Message;
//
//typedef struct {
//    Message message;
//    uint32_t randomNumber;
//} MessageRandomNumber;
//
//typedef struct {
//    Message message;
//} MessageGameBegin;
//
//typedef struct {
//    Message message;
//} MessageMove;
//
//typedef struct {
//    Message message;
//    BOOL player1Won;
//} MessageGameOver;

@interface MJViewController : UIViewController <MJPieceDelegate, GCHelperDelegate> {
//	uint32_t ourRandom;
//	BOOL receivedRandom;
//	NSString *otherPlayerID;
//	BOOL isPlayer1;
//	GameState gameState;
}
@property (strong, nonatomic) IBOutlet MJToolbar* toolbar;
@property (strong, nonatomic) IBOutlet MJBoard* board;
@property (strong, nonatomic) IBOutlet UIView *topToolbar;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;
@property (strong, nonatomic) IBOutlet UIButton* rotateButton;

- (IBAction)resetButtonPressed:(id)sender;
- (void) loadPieces;

@end
