
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
#import "MainMenu.h"
#import "GameSetUpData.h"
#import "EndGameViewController.h"
#import "EndGameData.h"
#import "MJClockWidget.h"
#import "MJAddTilesResource.h"
#import "MJBombResource.h"
#import "MJClusterResource.h"
#import "MJNegativeResource.h"

@implementation MJViewController

@synthesize topbar = _topbar;
@synthesize handle = _handle;
@synthesize territory = _territory;
@synthesize score = _score;
@synthesize board = _board;

@synthesize toolbar = _toolbar;
@synthesize zoomStepper	= _zoomStepper;

@synthesize players = _players;
@synthesize currentPlayer = _currentPlayer;

@synthesize isInitalLaunch = _isInitalLaunch;

@synthesize numberOfPlayers = _numberOfPlayers;

@synthesize mainMenuViewController = _mainMenuViewController;


@synthesize gameSetUpData = _gameSetUpData;
@synthesize gameTypeLabel = _gameTypeLabel;
@synthesize gameTypeLabelCounter = _gameTypeLabelCounter;

@synthesize secondsLeft = _secondsLeft;
@synthesize clockForTimeBasedGame = _clockForTimeBasedGame;

@synthesize endGameViewController = _endGameViewController;
@synthesize endGameData = _endGameData;
@synthesize roundCount = _roundCount;
@synthesize resourcePoints = _resourcePoints;

//@synthesize clock = _clock;

#pragma mark - Object Methods

- (IBAction)newGame:(id)sender {
	[_board newGame];
	[_board setBoardSize:_gameSetUpData.boardSize];
    NSLog(@"boardsize= %f %f", _gameSetUpData.boardSize.width, _gameSetUpData.boardSize.height);
	[_board zoomOutAnimated:YES];
	[_toolbar newGame];
	
	
    
    if ([_gameSetUpData.gameType isEqualToString:@"timeBased"]) {
        [self setUpTimeBasedGame];
    }
    if ([_gameSetUpData.gameType isEqualToString:@"turnBased"]) {
        [self setUpTurnBasedGame];
    }
    
	currentPlayerIndex = -1;
	//_roundCount = 0;
	_isInitalLaunch = YES;
    _resourcePoints = 50;
	[self createPlayers];
    
	[self createResources];
	[self nextPlayer];
}


- (void) createPlayers {
	_players = NULL;
	[self setPlayers:[[NSMutableArray alloc] init]];
	
	int numPlayers = _gameSetUpData.numberOfPlayers;
	
	for (int i = 0; i < numPlayers; i++) {
		MJPlayer* player = [[MJPlayer alloc] init];
		[player setViewController:self];
		[player setBoard:_board];
		[player setToolbar:_toolbar];
		
		MJTile* capital = [[MJTile alloc] initWithCoordinate:CGPointZero];
		
		
		int capitalOffset = 6;
		
		switch (i) {
			case 0:
				[player setHandle:@"Blue"];
				[player setColor:[UIColor blueColor]];
                [player setImageColor:@"Blue"];
				[capital setCoordinate:CGPointMake(capitalOffset, capitalOffset)];
				capital.tag = 1;
				break;
			case 1:
				[player setHandle:@"Red"];
				[player setColor:[UIColor redColor]];
                [player setImageColor:@"Red"];
				[capital setCoordinate:CGPointMake(capitalOffset, _board.boardSize.height - 1 - capitalOffset)];
				capital.tag = 1;
				break;
			case 2:
				[player setHandle:@"Green"];
				[player setColor:[UIColor greenColor]];
                [player setImageColor:@"Green"];
				[capital setCoordinate:CGPointMake(_board.boardSize.width - 1 - capitalOffset, _board.boardSize.height - 1 - capitalOffset)];
				capital.tag = 1;
				break;
			case 3:	
				[player setHandle:@"Yellow"];
				[player setColor:[UIColor yellowColor]];
                [player setImageColor:@"Yellow"];
				[capital setCoordinate:CGPointMake(_board.boardSize.width - 1 - capitalOffset, capitalOffset)];
				capital.tag = 1;
				break;
			case 4:
				[player setHandle:@"Kristi"];
				[player setColor:[UIColor yellowColor]];
                [player setImageColor:@"Yellow"];
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
		//2494 is equal to 50 squared minus the number of players (5)
		int numResourcesInSection = 1; // number of resources per section
        int numSplits = _board.boardSize.width/3;
        int section = 0;
        
        // special tile in the middle worth a lot of points
        __block MJResource* resource = [[MJResource alloc] initWithCoordinate:CGPointMake(_board.boardSize.width/2,_board.boardSize.height/2)];
        [resource setValue: (arc4random_uniform(250) + 250)];
        NSLog(@"Resource at coordinate:%@ has %i value", NSStringFromCGPoint(resource.coordinate) ,resource.value);
        //		NSArray* coords = [[NSArray alloc] initWithObjects:@"0,0", @"1,0", @"1,1", @"0,1", nil];
        //			[resource setTilesWithCoordinateArray:coords];
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Resource_Black.png"]]];
        [imageView setFrame:resource.bounds];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [resource addSubview:imageView];
            [_board addResource:resource];
        });
        
        for (int i=0; i < numSplits; i++) {
            for (int j=0; j < numSplits; j++) {
                while (_board.resources.count < numResourcesInSection*(section+1) && section < numSplits*numSplits) {
                    int randomX = arc4random() % (int)_board.boardSize.width/numSplits;
                    int randomY = arc4random() % (int)_board.boardSize.height/numSplits;
                    randomX = randomX + (i*(int)_board.boardSize.width/numSplits);
                    randomY = randomY + (j*(int)_board.boardSize.height/numSplits);
                    CGPoint point = CGPointMake(randomX, randomY);
                    
                    if (![_board resourceAtCoordinate:point] && ![_board resourcesAroundCoordinate:point] && ![_board tileAtCoordinate:point]) {
                        
                        NSUInteger randomInt = (arc4random() % 2) + 1;
                        
                        NSLog(@"Random Int: %d", randomInt);
                        
                        if (randomInt == 1) {
                            NSUInteger randomResourceInt = 4;//(arc4random_uniform(2)) + 1;
                            
                            if (randomResourceInt == 1) { //add tile resource
                                
                                __block MJAddTilesResource *resource = [[MJAddTilesResource alloc] initWithCoordinate:point];
                                [resource generateTiles];
                                NSLog(@"Resource at corrdinate:%@ has %i tiles", NSStringFromCGPoint(resource.coordinate),resource.tilesGenerated);
                                
                                UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"mysteryBox.png"]]];
                                [imageView setFrame:resource.bounds];
                                [imageView setContentMode:UIViewContentModeScaleAspectFill];
                                dispatch_sync(dispatch_get_main_queue(), ^{
                                    [resource addSubview:imageView];
                                    [_board addResource:resource];
                                });
                            }
                            
                            if (randomResourceInt == 2) { //bomb resource
                                
                                __block MJBombResource *resource = [[MJBombResource alloc] initWithCoordinate:point];
                                [resource generateBombs];
                                NSLog(@"Resource at corrdinate:%@ has %i bomb", NSStringFromCGPoint(resource.coordinate), resource.bombs);
                                
                                UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"mysteryBox.png"]]];
                                [imageView setFrame:resource.bounds];
                                [imageView setContentMode:UIViewContentModeScaleAspectFill];
                                dispatch_sync(dispatch_get_main_queue(), ^{
                                    [resource addSubview:imageView];
                                    [_board addResource:resource];
                                });
                            }
                            
                            if (randomResourceInt == 3) { //territory cluster resource
                                __block MJClusterResource *resource = [[MJClusterResource alloc] initWithCoordinate:point];
                                [resource generateTiles];
                                NSLog(@"Cluster Resource at corrdinate:%@ has %i tiles!", NSStringFromCGPoint(resource.coordinate), resource.tilesGenerated);
                                
                                UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"mysteryBox.png"]]];
                                [imageView setFrame:resource.bounds];
                                [imageView setContentMode:UIViewContentModeScaleAspectFill];
                                dispatch_sync(dispatch_get_main_queue(), ^{
                                    [resource addSubview:imageView];
                                    [_board addResource:resource];
                                });
                            }
                            
                            if (randomResourceInt == 4) { //negative point resource
                                
                                __block MJNegativeResource* resource = [[MJNegativeResource alloc] initWithCoordinate:point];
                                [resource setValue: (_resourcePoints)*-4];
                                NSLog(@"Resource at coordinate:%@ has %i value", NSStringFromCGPoint(resource.coordinate) ,resource.value);
                                //		NSArray* coords = [[NSArray alloc] initWithObjects:@"0,0", @"1,0", @"1,1", @"0,1", nil];
                                //			[resource setTilesWithCoordinateArray:coords];
                                UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"mysteryBox"]]];
                                [imageView setFrame:resource.bounds];
                                [imageView setContentMode:UIViewContentModeScaleAspectFill];
                                dispatch_sync(dispatch_get_main_queue(), ^{
                                    [resource addSubview:imageView];
                                    [_board addResource:resource];
                                });
                            }
                        }
                        
                        if (randomInt == 2) { //positive point resource                        
                            
                            __block MJResource* resource = [[MJResource alloc] initWithCoordinate:point];
                            [resource setValue: 50];
                            NSLog(@"Resource at coordinate:%@ has %i value", NSStringFromCGPoint(resource.coordinate) ,resource.value);
                            //		NSArray* coords = [[NSArray alloc] initWithObjects:@"0,0", @"1,0", @"1,1", @"0,1", nil];
                            //			[resource setTilesWithCoordinateArray:coords];
                            UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Resource_Green.png"]]];
                            [imageView setFrame:resource.bounds];
                            [imageView setContentMode:UIViewContentModeScaleAspectFill];
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [resource addSubview:imageView];
                                [_board addResource:resource];
                            });
                        }
                    }
                }
                section++;
            }
        }
	});
}

#pragma mark - Set Up Game Types

- (void)setUpTimeBasedGame {
    _gameTypeLabel.text = [NSString stringWithString:@"Time Left:"];
    
    if (_gameSetUpData.numberOfSeconds == 120) {
        _gameTypeLabelCounter.text = [NSString stringWithString:@"2:00"];
        _secondsLeft = 120;
    }
    if (_gameSetUpData.numberOfSeconds == 300) {
        _gameTypeLabelCounter.text = [NSString stringWithString:@"5:00"];
        _secondsLeft = 300;
    }
    if (_gameSetUpData.numberOfSeconds == 600) {
        _gameTypeLabelCounter.text = [NSString stringWithString:@"10:00"];
        _secondsLeft = 600;
    }
    
    [self createTimeBasedGameTimer]; 
//    MJClockWidget* clockWidget = [[MJClockWidget alloc] initWithCoder:nil];
//    [clockWidget createTimer];
}

- (void)createTimeBasedGameTimer {
    _clockForTimeBasedGame = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    [_clockForTimeBasedGame fire];
}

- (void)updateTimer {
    
    if (_secondsLeft > 0) {
        _secondsLeft--;
        NSUInteger minutes = (_secondsLeft % 3600) / 60;
        NSUInteger seconds = (_secondsLeft % 3600) % 60;
        _gameTypeLabelCounter.text = [NSString stringWithFormat:@"%2u:%02u", minutes, seconds];
        if (_secondsLeft <= 30) {
            _gameTypeLabelCounter.textColor = [UIColor redColor];
        }
    }
    else {
        [_clockForTimeBasedGame invalidate];
        [self endSequence];
    }
}

- (void) setUpTurnBasedGame {
    _gameTypeLabel.text = [NSString stringWithString:@"Turns Left:"];
    
    if (_gameSetUpData.numberOfTurns == 20) {
        _gameTypeLabelCounter.text = [NSString stringWithString:@"20"];
        _roundCount = 20;
        turnCount = _roundCount * _gameSetUpData.numberOfPlayers;
    }
    if (_gameSetUpData.numberOfTurns == 50) {
        _gameTypeLabelCounter.text = [NSString stringWithString:@"50"];
        _roundCount = 50;
        turnCount = _roundCount * _gameSetUpData.numberOfPlayers;
    }
    if (_gameSetUpData.numberOfTurns == 100) {
        _gameTypeLabelCounter.text = [NSString stringWithString:@"100"];
        _roundCount = 100;
        turnCount = _roundCount * _gameSetUpData.numberOfPlayers;
    }
}

- (void) updateTurnCount {
    
    turnCount--;
    
    if ((turnCount % _players.count ) == 0) _gameTypeLabelCounter.text = [NSString stringWithFormat:@"%d", --_roundCount];
    
    
    
    if (_roundCount == 0) {
        [self endSequence];
    }
    
}

#pragma mark - Zoom Methods

- (IBAction)zoomToCapital:(id)sender {
	//[self scrollToRect:_currentPlayer.capital.frame];
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


-(IBAction)zoom:(id)sender {
    if(_zoomStepper.value == 0){
        [_board zoomOutAnimated:YES];
    }
    else{
        [_board scrollRectToVisible:_currentPlayer.capital.frame animated:YES];
    }
}

#pragma mark - Game Play Methods

- (void) nextPlayer {
	if (_isInitalLaunch) {
        _isInitalLaunch = NO;
    }
	else {
        [_board zoomOutAnimated:YES];
        
		if ([_gameSetUpData.gameType isEqualToString:@"turnBased"]) {
			[self updateTurnCount];
		}
    }
    
	
	currentPlayerIndex < _players.count - 1 ? ++currentPlayerIndex : (currentPlayerIndex = 0);
	
	_currentPlayer = (MJPlayer*)[_players objectAtIndex:currentPlayerIndex];
    //[_currentPlayer updateNumberOfTilesToPlayWithNumber:0];
    [_toolbar animateInventoryCounter];
	[_currentPlayer updateScore];
	[_handle setText:_currentPlayer.handle];
	NSLog(@"Current Player: %@", _currentPlayer.handle);
	[_toolbar loadPlayer:_currentPlayer];
}

//- (void) updateScore {
//	[_currentPlayer updateTerritory];
//	[_territory setText:[NSString stringWithFormat:@"%i",_currentPlayer.territory]];
//	[_score setText:[NSString stringWithFormat:@"%i",_currentPlayer.score]];
//}

#pragma mark - Add Methods

- (void) addTile:(MJTile *)tile {
	[self.view addSubview:tile];
}

#pragma mark - End Sequence and Segue

- (void)endSequence {
    
    for (MJPlayer* player in _players) {
        player.combinedScore = player.territory + player.score;
    }
    
    for (MJPlayer* player in _players) {
        NSLog(@"Not in order: %d", player.combinedScore);
    }
    
    [self performSegueWithIdentifier:@"toEndGame" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    _endGameViewController = [segue destinationViewController];
    _endGameViewController.endGameData = _endGameData;
    _endGameViewController.numberOfPlayers = _gameSetUpData.numberOfPlayers;
    _endGameViewController.players = _players;
}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        GameSetUpData *tmp = [[GameSetUpData alloc] init];
        _gameSetUpData = tmp;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    EndGameViewController *egVC = [[EndGameViewController alloc] init];
    _endGameViewController = egVC;
    
    EndGameData *endGameTmp = [[EndGameData alloc] init];
    _endGameData = endGameTmp;
    
	[self newGame:self];
	// Do any additional setup after loading the view, typically from a nib.
}



- (void)viewDidUnload
{
	//IBOutlets
    [self setGameTypeLabel:nil];
    [self setGameTypeLabelCounter:nil];
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
