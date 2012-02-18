//
//  MJViewController.m
//  MAKJAM
//
//  Created by Andrew Huss on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJViewController.h"
#import "MJPiece.h"
#import "MJPlayer.h"

@implementation MJViewController

@synthesize board = _board;
@synthesize topToolbar = _topToolbar;
@synthesize resetButton = _resetButton;

@synthesize toolbar = _toolbar;
@synthesize titleLabel = _titleLabel;
@synthesize doneButton = _doneButton;
@synthesize rotateButton = _rotateButton;

@synthesize pieceData = _pieceData;
@synthesize players = _players;

-(id) initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder]) == nil) {
		return self;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
/*
//- (void)setGameState:(GameState)state {
//    
//    gameState = state;
//    if (gameState == kGameStateWaitingForMatch) {
//		NSLog(@"Waiting for match");
////        [debugLabel setString:@"Waiting for match"];
//    } else if (gameState == kGameStateWaitingForRandomNumber) {
//		NSLog(@"Waiting for rand #");
////        [debugLabel setString:@"Waiting for rand #"];
//    } else if (gameState == kGameStateWaitingForStart) {
//		NSLog(@"Waiting for start");
////        [debugLabel setString:@"Waiting for start"];
//    } else if (gameState == kGameStateActive) {
//		NSLog(@"Active");
////        [debugLabel setString:@"Active"];
//    } else if (gameState == kGameStateDone) {
//		NSLog(@"Done");
////        [debugLabel setString:@"Done"];
//    } 
//    
//}
//
//- (void)sendData:(NSData *)data {
//    NSError *error;
//    BOOL success = [[GCHelper sharedInstance].match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
//    if (!success) {
//        NSLog(@"Error sending init packet");
//        [self matchEnded];
//    }
//}
//
//- (void)sendRandomNumber {
//	
//    MessageRandomNumber message;
//    message.message.messageType = kMessageTypeRandomNumber;
//    message.randomNumber = ourRandom;
//    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageRandomNumber)];    
//    [self sendData:data];
//}
//
//- (void)sendGameBegin {
//	
//    MessageGameBegin message;
//    message.message.messageType = kMessageTypeGameBegin;
//    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageGameBegin)];    
//    [self sendData:data];
//	
//}
//
//- (void)sendMove {
//    
//    MessageMove message;
//    message.message.messageType = kMessageTypeMove;
//    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageMove)];    
//    [self sendData:data];
//    
//}
//
//- (void)sendGameOver:(BOOL)player1Won {
//    
//    MessageGameOver message;
//    message.message.messageType = kMessageTypeGameOver;
//    message.player1Won = player1Won;
//    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageGameOver)];    
//    [self sendData:data];
//    
//}
//
//- (void)tryStartGame {
//	
//    if (isPlayer1 && gameState == kGameStateWaitingForStart) {
//        [self setGameState:kGameStateActive];
//        [self sendGameBegin];
//    }
//	
//}
//
//- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
//    
//    // Store away other player ID for later
//    if (otherPlayerID == nil) {
//        otherPlayerID = playerID;
//    }
//    
//    Message *message = (Message *) [data bytes];
//    if (message->messageType == kMessageTypeRandomNumber) {
//        
//        MessageRandomNumber * messageInit = (MessageRandomNumber *) [data bytes];
//        NSLog(@"Received random number: %ud, ours %ud", messageInit->randomNumber, ourRandom);
//        bool tie = false;
//        
//        if (messageInit->randomNumber == ourRandom) {
//            NSLog(@"TIE!");
//            tie = true;
//            ourRandom = arc4random();
//            [self sendRandomNumber];
//        } else if (ourRandom > messageInit->randomNumber) {            
//            NSLog(@"We are player 1");
//            isPlayer1 = YES;            
//        } else {
//            NSLog(@"We are player 2");
//            isPlayer1 = NO;
//        }
//        
//        if (!tie) {
//            receivedRandom = YES;    
//            if (gameState == kGameStateWaitingForRandomNumber) {
//                [self setGameState:kGameStateWaitingForStart];
//            }
//            [self tryStartGame];        
//        }
//        
//    } else if (message->messageType == kMessageTypeGameBegin) {        
//        
//        [self setGameState:kGameStateActive];
////        [self setupStringsWithOtherPlayerId:playerID];
//        
//    } else if (message->messageType == kMessageTypeMove) {     
//        
//        NSLog(@"Received move");
//        
//        if (isPlayer1) {
////            [player2 moveForward];
//        } else {
////            [player1 moveForward];
//        }        
//    } else if (message->messageType == kMessageTypeGameOver) {        
//        
//        MessageGameOver * messageGameOver = (MessageGameOver *) [data bytes];
//        NSLog(@"Received game over with player 1 won: %d", messageGameOver->player1Won);
//        
//        if (messageGameOver->player1Won) {
//            [self endScene:kEndReasonLose];    
//        } else {
//            [self endScene:kEndReasonWin];    
//        }
//        
//    }    
//}
*/

- (IBAction)resetButtonPressed:(id)sender {
	/*
//	ourRandom = arc4random();
//	[self setGameState:kGameStateWaitingForMatch];
//	[[GCHelper sharedInstance] findMatchWithMinPlayers:2 maxPlayers:2 viewController:self delegate:self];
	
	//@"up_left", @"up_right", @"left_down", @"left_up", @"right_down", @"right_up", 
	NSArray* pieceNames = [[NSArray alloc] initWithObjects:@"Cross", @"down_left", @"down_right", @"H", @"U", @"vertical", @"W", nil];
	//	float height = _toolbar.frame.size.height - (2.0f * 10);
	int diffPieces = [pieceNames count];
	int numPieces = diffPieces * 2;
	for (int i = 0; i < numPieces; i++) {
		MJPiece* piece = [[MJPiece alloc] initWithImage:[UIImage imageNamed:[pieceNames objectAtIndex:i % diffPieces]]];
		
		[piece setParentViewController:self];
		[piece setBoard:_board];
		[piece setToolbar:_toolbar];
		
		[piece setDelegate:_toolbar];
		[piece.delegate addPiece:piece];
	}
	*/
	[[NSNotificationCenter defaultCenter] postNotificationName:@"NewGame" object:self];
}

- (IBAction)doneButtonPressed:(id)sender {
	NSLog(@"Done Button Pressed");
	[self nextPlayer];
}

- (void) newGame {
	NSLog(@"ViewController: received new game notification");
	if (!_pieceData) [self retrievePieceData];
	currentPlayer = -1;
	int numPlayers = 2;
	for (int i = 0; i < numPlayers; i++) {
		[self addPlayer];
	}
	
	[self nextPlayer];
//	[_toolbar resetToolbar];
//	[_board resetBoard];
//	int boardWidth = 30;
//	int boardHeight = 30;
//	[_board setBoardSize:CGSizeMake(boardWidth, boardHeight)];

}

- (void) addPlayer {
	NSLog(@"Adding new player");
	if (!_players) _players = [[NSMutableArray alloc] init];
	MJPlayer* player = [[MJPlayer alloc] init];
	player.handle = [NSString stringWithFormat:@"%i", _players.count+1];
	for (NSString* key in _pieceData) {
		MJPiece* piece = [[MJPiece alloc] initWithImage:[UIImage imageNamed:key]];
		[piece setTransparentTiles:[_pieceData objectForKey:key]];
		[piece setParentViewController:self];
		[piece setBoard:_board];
		[piece setToolbar:_toolbar];
		[piece setPlayed:NO];
		[player.pieces addObject:piece];
		NSLog(@"Added Piece: %@", key);
	}
	[_players addObject:player];
}

- (void) nextPlayer {
	currentPlayer < _players.count - 1 ? ++currentPlayer : (currentPlayer = 0);
	MJPlayer* player = (MJPlayer*)[_players objectAtIndex:currentPlayer];
	[_toolbar loadPlayersPieces:player];
	_titleLabel.text = player.handle;
	NSLog(@"Current Player: %i", currentPlayer);
	NSLog(@"Number of pieces on toolbar: %i", player.pieces.count - [player piecesInPlay]);
}

- (void) retrievePieceData {
	NSString *errorDesc = nil;
	NSPropertyListFormat format;
	NSString *plistPath;
	plistPath = [[NSBundle mainBundle] pathForResource:@"PieceData" ofType:@"plist"];
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
	_pieceData = (NSDictionary *)[NSPropertyListSerialization
							  propertyListFromData:plistXML
							  mutabilityOption:NSPropertyListMutableContainersAndLeaves
							  format:&format
							  errorDescription:&errorDesc];
	if (!_pieceData) {
		NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
		abort();
	}
	NSLog(@"Retrieved Piece Data");
//	NSMutableArray* tmp = [[NSMutableArray alloc] init];
//	for (NSString* key in _pieceData) {
//		MJPiece* piece = nil;
//		piece = [[MJPiece alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", key]]];
//		NSMutableArray* transparentTiles = [[NSMutableArray alloc] init];
//		for (NSString* s in (NSArray*)[_pieceData objectForKey:key]) {
//			[transparentTiles addObject:[NSString stringWithFormat:@"{%@}", s]];
//		}
//		
//		[piece setTransparentTiles:transparentTiles];
//		[piece setParentViewController:self];
//		[piece setBoard:_board];
//		[piece setToolbar:_toolbar];
//		[piece setPlayed:NO];
//		[tmp addObject:piece];
//		NSLog(@"Added new piece");
//	}
}

#pragma mark - MJPieceDelegate Methods

- (BOOL) addPiece:(MJPiece *)piece {
	//need to animate this!!!!!!!!
	if (![piece.superview isEqual:_board]) {
		[_board scalePiece:piece];//Scales the piece to the current board zoom scale
	}
	[self.view addSubview:piece];
	return YES;
}

- (BOOL) removePiece:(MJPiece *)piece {
	if ([self isEqual:piece.superview]) {
		[piece removeFromSuperview];
		return YES;
	}
	return NO;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newGame) name:@"NewGame" object:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"NewGame" object:self];
}

- (void)viewDidUnload
{
	[self setTopToolbar:nil];
	[self setResetButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

//#pragma mark - GCHelperDelegate
//
//- (void)matchStarted {    
//    NSLog(@"Match started");        
//	if (receivedRandom) {
//        [self setGameState:kGameStateWaitingForStart];
//    } else {
//        [self setGameState:kGameStateWaitingForRandomNumber];
//    }
//    [self sendRandomNumber];
//    [self tryStartGame];
//}
//
//- (void)matchEnded {    
//    NSLog(@"Match ended");    
//}
//
//- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
//    NSLog(@"Received data");
//}

@end