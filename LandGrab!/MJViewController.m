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

@implementation MJViewController

@synthesize topbar = _topbar;
@synthesize score = _score;
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

- (void) newGame {
	NSLog(@"ViewController: received new game notification");
	[self setPlayers:nil];
	currentPlayer = -1;
	int numPlayers = 1;
	for (int i = 0; i < numPlayers; i++) {
		[self addPlayer];
	}
	[self nextPlayer];
	
}
- (void) addPlayer {
	if (!_players) {
		_players = [[NSMutableArray alloc] init];
	}
	MJPlayer* player = [[MJPlayer alloc] init];
	[player setViewController:self];
	[player setBoard:_board];
	[player setToolbar:_toolbar];
	[player loadDebugPieces];
	[_players addObject:player];
}
- (void) nextPlayer {
	currentPlayer < _players.count - 1 ? ++currentPlayer : (currentPlayer = 0);
	NSLog(@"Current Player: %i", currentPlayer);
	
	MJPlayer* player = (MJPlayer*)[_players objectAtIndex:currentPlayer];
	NSLog(@"Piece Count: %i", player.pieces.count);
	[_toolbar loadPlayer:player];
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
	[self newGame];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
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

- (void) addPiece:(MJPiece *)piece {
	NSLog(@"Adding to viewController at: (%f, %f)", piece.lastTouch.x, piece.lastTouch.y);
	[piece addAsSubviewToView:self.view];
}

- (void) removePiece:(MJPiece *)piece {
	if ([piece.superview isEqual:self.view]) {
		[piece removeFromSuperview];
	}
	else abort();
}

@end
