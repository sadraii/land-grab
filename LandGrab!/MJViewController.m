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
	currentPlayer = -1;
	turnCount = 0;
	int numPlayers = 1;
	for (int i = 0; i < numPlayers; i++) {
		MJPlayer* player = [[MJPlayer alloc] init];
		[player setViewController:self];
		[player setBoard:_board];
		[player setToolbar:_toolbar];
		switch (i) {
			case 0:
				[player setHandle:@"Andrew"];
				[player setColor:[UIColor blueColor]];
				break;
			case 1:
				[player setHandle:@"Jason"];
				[player setColor:[UIColor redColor]];
				break;
			case 2:
				[player setHandle:@"Max"];
				[player setColor:[UIColor greenColor]];
				break;
			case 3:	
				[player setHandle:@"Mostafa"];
				[player setColor:[UIColor brownColor]];
				break;
			case 4:
				[player setHandle:@"Kristi"];
				[player setColor:[UIColor yellowColor]];
				break;
		}
		[_players addObject:player];
	}
	[self nextPlayer];
}

- (void) nextPlayer {
	currentPlayer < _players.count - 1 ? ++currentPlayer : (currentPlayer = 0);
	if (!(currentPlayer % _players.count - 1)) turnCount++;
	MJPlayer* player = (MJPlayer*)[_players objectAtIndex:currentPlayer];
	[player updateTerritory];
	[_toolbar loadPlayer:player];
	[_handle setText:player.handle];
	[_territory setText:[NSString stringWithFormat:@"%i",player.territory]];
}

- (void) createDebugPiece {
	MJPiece* piece = [[MJPiece alloc] init];
	[piece setViewController:self];
	[piece setBoard:_board];
	[piece setToolbar:_toolbar];
	[piece loadDebugTiles];
	[piece addAsSubviewToView:self.view];
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
