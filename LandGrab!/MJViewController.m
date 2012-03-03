
//  MJViewController.m
//  LandGrab!
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJViewController.h"
#import "MJPlayer.h"
#import "MJToolbar.h"
#import "MJBoard.h"
#import "MJTopBar.h"
#import "MJTile.h"
#import "MJResource.h"

@implementation MJViewController

@synthesize topbar = _topbar;
@synthesize handle = _handle;
@synthesize territory = _territory;
@synthesize score = _score;
@synthesize board = _board;
@synthesize toolbar = _toolbar;

@synthesize players = _players;
@synthesize currentPlayer = _currentPlayer;

@synthesize isInitalLaunch = _isInitalLaunch;



#pragma mark - Object Methods

- (IBAction)newGame:(id)sender {
	[_board newGame];
	[_board setBoardSize:CGSizeMake(50, 50)];
	[_board setZoomScale:_board.minimumZoomScale];
	[_toolbar newGame];
	currentPlayerIndex = -1;
	turnCount = 0;
	_isInitalLaunch = YES;
	[self createPlayers];
	[self createResources];
	[self nextPlayer];
//	[(UIView*)_board.containerView setNeedsDisplay]; 
}

- (void) createPlayers {
	_players = NULL;
	[self setPlayers:[[NSMutableArray alloc] init]];
	
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
				capital.tag = 1;
				break;
			case 1:
				[player setHandle:@"JSON"];
				[player setColor:[UIColor redColor]];
				[capital setCoordinate:CGPointMake(capitalOffset, _board.boardSize.height - 1 - capitalOffset)];
				capital.tag = 1;
				break;
			case 2:
				[player setHandle:@"Max"];
				[player setColor:[UIColor greenColor]];
				[capital setCoordinate:CGPointMake(_board.boardSize.width - 1 - capitalOffset, _board.boardSize.height - 1 - capitalOffset)];
				capital.tag = 1;
				break;
			case 3:	
				[player setHandle:@"Mostafa"];
				[player setColor:[UIColor magentaColor]];
				[capital setCoordinate:CGPointMake(_board.boardSize.width - 1 - capitalOffset, capitalOffset)];
				capital.tag = 1;
				break;
			case 4:
				[player setHandle:@"Kristi"];
				[player setColor:[UIColor yellowColor]];
				[capital setCoordinate:CGPointMake((int)((_board.boardSize.width - 1) / 2), (int)((_board.boardSize.height - 1)/2))];
				capital.tag = 1;
				break;
		}
		[_players addObject:player];
		
		[player setCapital:capital];
		
		[capital setIsPlayed:YES];
		[capital setUserInteractionEnabled:NO];
		[capital setTag:1];
		[capital setBackgroundColor:player.color];
		[capital setPlayer:player];
		[_board.pieces addObject:capital];
		[(UIView*)_board.containerView addSubview:capital];
	}
}

- (void) createResources {
	dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(concurrentQueue, ^{
		int numResources = 10;
		while (_board.resources.count < numResources) {
			int randomX = arc4random() % (int)_board.boardSize.width;
			int randomY = arc4random() % (int)_board.boardSize.height;
			CGPoint point = CGPointMake(randomX, randomY);
			if (![_board resourceAtCoordinate:point] && ![_board tileAtCoordinate:point]) {
				__block MJResource* resource = [[MJResource alloc] initWithCoordinate:point];
				int minValue = 50;
				[resource setValue:(arc4random() % minValue) + minValue];
				//		NSArray* coords = [[NSArray alloc] initWithObjects:@"0,0", @"1,0", @"1,1", @"0,1", nil];
				//			[resource setTilesWithCoordinateArray:coords];
				dispatch_sync(dispatch_get_main_queue(), ^{
					[_board addResource:resource];
				});
			}
//			NSLog(@"Random Coordinate: (%i, %i)", randomX, randomY);
//			NSMutableArray* coords = [[NSMutableArray alloc] init];
//			for (int n = 0; n < arc4random() % 3; n++) {
//				int x = arc4random() % 3;
//				int y = arc4random() % 3;
//				[coords addObject:[NSString stringWithFormat:@"%i,%i", x, y]];
//			}
		}
	});
}

- (IBAction)zoomToCapital:(id)sender {
	[self scrollToRect:_currentPlayer.capital.frame];
}

- (void) scrollToRect:(CGRect)rect {
	CGRect boardRect = _board.bounds;
	boardRect.origin.x = (rect.origin.x + (rect.size.width / 2)) - (boardRect.size.width / 2);
	boardRect.origin.y = (rect.origin.y + (rect.size.height / 2)) - (boardRect.size.height / 2);
	
	[_board setZoomScale:1 animated:YES];
	[_board scrollRectToVisible:boardRect animated:YES];
	
//	[UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^ {
////		[_board scrollRectToVisible:boardRect animated:NO];
////		[_board setZoomScale:1];
//	}completion:^(BOOL finished) {
//		NSLog(@"Yay scroll!");
//	}];
	
	
}
-(void) zoomOut {
	[UIView animateWithDuration:1.5f delay:1.0f options:UIViewAnimationOptionCurveEaseInOut animations:^ {
		[_board setZoomScale:_board.minimumZoomScale animated:NO];	
	}completion:^(BOOL finished) {
		[(UIView*)_board.containerView setNeedsDisplay];
		NSLog(@"Yay zoom out");
	}];
}

- (void) nextPlayer {
	currentPlayerIndex < _players.count - 1 ? ++currentPlayerIndex : (currentPlayerIndex = 0);
	if (!(currentPlayerIndex % _players.count - 1)) turnCount++;
	_currentPlayer = (MJPlayer*)[_players objectAtIndex:currentPlayerIndex];
	//[_currentPlayer updateTerritory];
	[_toolbar loadPlayer:_currentPlayer];
	[_handle setText:_currentPlayer.handle];
	NSLog(@"Current Player: %@", _currentPlayer.handle);
	[_territory setText:[NSString stringWithFormat:@"%i",_currentPlayer.territory]];
	[_score setText:[NSString stringWithFormat:@"%i",_currentPlayer.score]];
	if (_isInitalLaunch) {
		_isInitalLaunch = NO;
	}
	else {
		[self zoomOut];
	}
}

- (void) addTile:(MJTile *)tile {
	[self.view addSubview:tile];
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
	if (_board) {
		[_board updateZoomScale];
	}
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	    return YES;
	}
}

@end
