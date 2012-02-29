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

@synthesize topbar = _topbar;
@synthesize handle = _handle;
@synthesize territory = _territory;
@synthesize board = _board;
@synthesize toolbar = _toolbar;

@synthesize players = _players;
@synthesize currentPlayer = _currentPlayer;

#pragma mark - Object Methods

- (IBAction)newGame:(id)sender {
	[_board newGame];
	[_board setBoardSize:CGSizeMake(30, 30)];
	[_toolbar newGame];
	[self setPlayers:[[NSMutableArray alloc] init]];
	currentPlayerIndex = -1;
	turnCount = 0;
	int numPlayers = 5;
	for (int i = 0; i < numPlayers; i++) {
		MJPlayer* player = [[MJPlayer alloc] init];
		[player setViewController:self];
		[player setBoard:_board];
		[player setToolbar:_toolbar];
		
		
		MJTile* capital = [[MJTile alloc] initWithCoordinate:CGPointZero];
		
		
		int capitalOffset = 6;
		
		switch (i) {
			case 0:
				[player setHandle:@"Andrew"];
				[player setColor:[UIColor blueColor]];
				[capital setCoordinate:CGPointMake(capitalOffset, capitalOffset)];
				break;
			case 1:
				[player setHandle:@"Jason"];
				[player setColor:[UIColor redColor]];
				[capital setCoordinate:CGPointMake(capitalOffset, _board.boardSize.height - 1 - capitalOffset)];
				break;
			case 2:
				[player setHandle:@"Max"];
				[player setColor:[UIColor greenColor]];
				[capital setCoordinate:CGPointMake(_board.boardSize.width - 1 - capitalOffset, _board.boardSize.height - 1 - capitalOffset)];
				break;
			case 3:	
				[player setHandle:@"Mostafa"];
				[player setColor:[UIColor brownColor]];
				[capital setCoordinate:CGPointMake(_board.boardSize.width - 1 - capitalOffset, capitalOffset)];
				break;
			case 4:
				[player setHandle:@"Kristi"];
				[player setColor:[UIColor yellowColor]];
				[capital setCoordinate:CGPointMake((int)((_board.boardSize.width - 1) / 2), (int)((_board.boardSize.height - 1)/2))];
				break;
		}
		[_players addObject:player];
		
		[player setCapital:capital];
		
		[capital setIsPlayed:YES];
		[capital setTag:1];
		[capital setBackgroundColor:player.color];
		[capital setPlayer:player];
		
		[_board.pieces addObject:capital];
		[_board addSubview:capital];
//		[_board addTile:capital];
	}
	[self nextPlayer];
}

- (IBAction)zoomToCapital:(id)sender {
	[self zoomToRect:_currentPlayer.capital.frame];
}

- (void) zoomToRect:(CGRect)rect {
	CGRect boardRect = _board.bounds;
	boardRect.origin.x = (rect.origin.x + (rect.size.width / 2)) - (boardRect.size.width / 2);
	boardRect.origin.y = (rect.origin.y + (rect.size.height / 2)) - (boardRect.size.height / 2);
	[_board scrollRectToVisible:boardRect animated:YES];
}

- (void) nextPlayer {
	currentPlayerIndex < _players.count - 1 ? ++currentPlayerIndex : (currentPlayerIndex = 0);
	if (!(currentPlayerIndex % _players.count - 1)) turnCount++;
	NSLog(@"Current Player: %i", currentPlayerIndex);
	_currentPlayer = (MJPlayer*)[_players objectAtIndex:currentPlayerIndex];
	[_currentPlayer updateTerritory];
	[_toolbar loadPlayer:_currentPlayer];
	[_handle setText:_currentPlayer.handle];
	[_territory setText:[NSString stringWithFormat:@"%i",_currentPlayer.territory]];
	if (_currentPlayer.lastPlayedTile) {
		[self zoomToRect:_currentPlayer.lastPlayedTile.frame];
	}
	else {
		[self zoomToRect:_currentPlayer.capital.frame];
	}
}

- (void) addTile:(MJTile *)tile {
	[self.view addSubview:tile];
}

- (void) addPiece:(MJPiece *)piece {
	[piece addAsSubviewToView:self.view];
}


#pragma mark - Memory Warning
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
	//IBOutlets
    [super viewDidUnload];
	[self setTopbar:nil];
	[self setHandle:nil];
	[self setTerritory:nil];
	[self setBoard:nil];
	[self setTopbar:nil];
	
	//Others
	[self setPlayers:nil];
	[self setCurrentPlayer:nil];
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

@end
