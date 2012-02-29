//
//  MJViewController.m
//  LandGrab!
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJViewController.h"
#import "MJPiece.h"
#import "MJPlayer.h"
#import "MJToolbar.h"
#import "MJBoard.h"
#import "MJTopBar.h"
#import "MJTile.h"

@implementation MJViewController

@synthesize NewGame = _NewGame;
@synthesize topbar = _topbar;
@synthesize handle = _handle;
@synthesize territory = _territory;

@synthesize board = _board;
@synthesize toolbar = _toolbar;

@synthesize players = _players;
@synthesize currentPlayer = _currentPlayer;

#pragma mark - Object Methods

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (IBAction)newGame:(id)sender {
	[_board newGame];
	[_toolbar newGame];
	[self setPlayers:[[NSMutableArray alloc] init]];
	currentPlayerIndex = -1;
	turnCount = 0;
	int numPlayers = 4;
	for (int i = 0; i < numPlayers; i++) {
		MJPlayer* player = [[MJPlayer alloc] init];
		[player setViewController:self];
		[player setBoard:_board];
		[player setToolbar:_toolbar];
		switch (i) {
			case 0:
				[player setHandle:@"Andrew"];
				[player setColor:[UIColor blueColor]];
				[player setCapitalLocation:CGPointMake(0, 0)];
				break;
			case 1:
				[player setHandle:@"Jason"];
				[player setColor:[UIColor redColor]];
				[player setCapitalLocation:CGPointMake(0, _board.boardSize.height - 1)];
				break;
			case 2:
				[player setHandle:@"Max"];
				[player setColor:[UIColor greenColor]];
				[player setCapitalLocation:CGPointMake(_board.boardSize.width - 1, _board.boardSize.height - 1)];
				break;
			case 3:	
				[player setHandle:@"Mostafa"];
				[player setColor:[UIColor brownColor]];
				[player setCapitalLocation:CGPointMake(_board.boardSize.width - 1, 0)];
				break;
			case 4:
				[player setHandle:@"Kristi"];
				[player setColor:[UIColor yellowColor]];
				[player setCapitalLocation:CGPointMake((int)((_board.boardSize.width - 1) / 2), (int)((_board.boardSize.height - 1)/2))];
				break;
		}
		[_players addObject:player];
	}
	[self nextPlayer];
}

- (void) nextPlayer {
	currentPlayerIndex < _players.count - 1 ? ++currentPlayerIndex : (currentPlayerIndex = 0);
	if (!(currentPlayerIndex % _players.count - 1)) turnCount++;
	_currentPlayer = (MJPlayer*)[_players objectAtIndex:currentPlayerIndex];
	[_currentPlayer updateTerritory];
	[_toolbar loadPlayer:_currentPlayer];
	[_handle setText:_currentPlayer.handle];
	[_territory setText:[NSString stringWithFormat:@"%i",_currentPlayer.territory]];
	if (_currentPlayer.lastPlayedTile) {
		[_board scrollRectToVisible:_currentPlayer.lastPlayedTile.frame animated:YES];
	}
	else {
		[self zoomToCapital:self];
	}
}

- (IBAction)zoomToCapital:(id)sender {
	[_board scrollRectToVisible:CGRectMake(_currentPlayer.capitalLocation.x * TILE_SIZE, _currentPlayer.capitalLocation.y * TILE_SIZE, TILE_SIZE, TILE_SIZE) animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self newGame:self];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
	[self setNewGame:nil];
	[self setTerritory:nil];
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
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	    return YES;
	}
}

#pragma mark - Piece Delegate

- (void) addPiece:(id)piece {
	if ([piece isKindOfClass:[MJTile class]]) {
		MJTile* tile = (MJTile*)piece;
		[self.view addSubview:tile];
	}
	else if ([piece isKindOfClass:[MJPiece class]]) {
		MJPiece* piece = (MJPiece*)piece;
		[piece addAsSubviewToView:self.view];
	}
	else abort();
}

- (void) removePiece:(id)piece {
	if ([piece isKindOfClass:[MJTile class]]) {
		MJTile* tile = (MJTile*)piece;
	}
	else if ([piece isKindOfClass:[MJPiece class]]) {
		MJPiece* piece = (MJPiece*)piece;
		if ([piece.superview isEqual:self.view]) {
			[piece removeFromSuperview];
		}
	}
	else abort();
}

@end
