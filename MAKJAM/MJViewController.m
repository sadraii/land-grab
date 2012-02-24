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
#import "MJToolbar.h"

@implementation MJViewController

@synthesize board = _board;
@synthesize topToolbar = _topToolbar;
@synthesize resetButton = _resetButton;
@synthesize volume = _volume;
@synthesize toolbar = _toolbar;
@synthesize titleLabel = _titleLabel;
@synthesize doneButton = _doneButton;
@synthesize rotateButton = _rotateButton;

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

- (IBAction)resetButtonPressed:(id)sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"NewGame" object:self];
}

/*
 Calls the next player method
 */
- (IBAction)doneButtonPressed:(id)sender {
	NSLog(@"Done Button Pressed");
	[self nextPlayer];
}

/*
 Called when the NewGame notification is posted
 Sets the currentPlayer to -1 so that when next player is called it will start off at player 0
 Clears the player array
 adds players into the player array
 Calls next player
 */
- (void) newGame {
	NSLog(@"ViewController: received new game notification");
	[self setPlayers:nil];
	currentPlayer = -1;
	int numPlayers = 2;
	for (int i = 0; i < numPlayers; i++) {
		[self addPlayer];
	}
	[self nextPlayer];
}

/*
 Initializes a new player and adds it to the Player array
 */
- (void) addPlayer {
	NSLog(@"Adding new player");
	if (!_players) _players = [[NSMutableArray alloc] init];
	MJPlayer* player = [[MJPlayer alloc] init];
	player.handle = [NSString stringWithFormat:@"%i", _players.count+1];
	int startingPieces = 1;
	for (int i = 0; i < startingPieces; i++) {
		MJPiece* piece = [[MJPiece alloc] init];
		[piece loadDefaultTiles];
		[piece setViewController:self];
		[piece setPlayer:player];
		[player.pieces addObject:piece];
	}
	[_players addObject:player];
}

/*
 Loads the next player
 */
- (void) nextPlayer {
	currentPlayer < _players.count - 1 ? ++currentPlayer : (currentPlayer = 0);
	
	MJPlayer* player = (MJPlayer*)[_players objectAtIndex:currentPlayer];
	_titleLabel.text = player.handle;
	NSLog(@"Current Player: %i", currentPlayer);
	NSLog(@"Number of pieces on toolbar: %i", player.pieces.count - [player piecesInPlay]);
	[_toolbar loadPlayersPieces:player];
}

#pragma mark - MJPieceDelegate Methods

- (BOOL) addPiece:(MJPiece *)piece {
	//need to animate this!!!!!!!!
	if (![piece.superview isEqual:_board]) {
		[_board scalePiece:piece];//Scales the piece to the current board zoom scale
	}
	
	[piece addAsSubviewToView:self.view];
	
	return YES;
}

- (BOOL) removePiece:(MJPiece *)piece {
	return YES;
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
    [self setVolume:nil];
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

@end