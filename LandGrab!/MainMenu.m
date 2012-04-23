//
//  MainMenu.m
//  LandGrab!
//
//  Created by Helen Saenz on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenu.h"
#import "MJViewController.h"
#import "GameSetUpData.h"

@implementation MainMenu
@synthesize gameSetUp = _gameSetUp;
@synthesize isViewControllerSetUp = _isViewControllerSetUp;
@synthesize mjViewController = _mjViewController;
@synthesize counter = _counter;
@synthesize startNewGame = _startNewGame;
@synthesize twoPlayersButton = _twoPlayersButton;
@synthesize threePlayersButton = _threePlayersButton;
@synthesize fourPlayersButton = _fourPlayersButton;
@synthesize timeBasedButton = _timeBasedButton;
@synthesize turnBasedButton = _turnBasedButton;     
@synthesize twoMinutesButton = _twoMinutesButton;
@synthesize fiveMinutesButton = _fiveMinutesButton;
@synthesize tenMinutesButton = _tenMinutesButton;
@synthesize twentyTurnsButton = _twentyTurnsButton;
@synthesize fiftyTurnsButton = _fiftyTurnsButton;
@synthesize hundredTurnsButton = _hundredTurnsButton;
@synthesize label = _label;
@synthesize boardsize20x20 = _boardsize20x20;
@synthesize boardsize30x30 = _boardsize30x30;
@synthesize boardsize50x50 = _boardsize50x50;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self reset];
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void) reset {
	MJViewController *mjVC = [[MJViewController alloc] initWithCoder:nil];
    _mjViewController = mjVC;
    
    GameSetUpData *tmp = [[GameSetUpData alloc] init];
    _gameSetUp = tmp;
	
    [_label setText:@"How many players?"];
    _timeBasedButton.hidden = YES;
    _turnBasedButton.hidden = YES;
    _twoMinutesButton.hidden = YES;
    _fiveMinutesButton.hidden = YES;
    _tenMinutesButton.hidden = YES;
    _twentyTurnsButton.hidden = YES;
    _fiftyTurnsButton.hidden = YES;
    _hundredTurnsButton.hidden = YES;
    _boardsize20x20.hidden = YES;
    _boardsize30x30.hidden = YES;
    _boardsize50x50.hidden = YES;
	_twoPlayersButton.hidden = NO;
	_threePlayersButton.hidden = NO;
	_fourPlayersButton.hidden = NO;
}

- (void)viewDidUnload
{
  
    [self setTwoPlayersButton:nil];
    [self setThreePlayersButton:nil];
    [self setFourPlayersButton:nil];
    [self setTimeBasedButton:nil];
    [self setTurnBasedButton:nil];
    [self setTwoMinutesButton:nil];
    [self setFiveMinutesButton:nil];
    [self setTenMinutesButton:nil];
    [self setTwentyTurnsButton:nil];
    [self setFiftyTurnsButton:nil];
    [self setHundredTurnsButton:nil];
    [self setStartNewGame:nil];
    [self setLabel:nil];
    [self setBoardsize20x20:nil];
    [self setBoardsize30x30:nil];
    [self setBoardsize50x50:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueIdentifer = [segue identifier];
    
    _mjViewController = [segue destinationViewController]; 
    
//    [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationCurveEaseIn animations:^ {
//        self.view.hidden = YES;
//    }completion:^(BOOL finished) {
        if ([segueIdentifer isEqualToString:@"from2MinToGame"]) {
            _gameSetUp.numberOfSeconds = 120;
            _mjViewController.gameSetUpData = _gameSetUp;
            [_gameSetUp printData];
        }
        if ([segueIdentifer isEqualToString:@"from5MinToGame"]) {
            _gameSetUp.numberOfSeconds = 300;
            _mjViewController.gameSetUpData = _gameSetUp;
            [_gameSetUp printData];
        }
        if ([segueIdentifer isEqualToString:@"from10MinToGame"]) {
            _gameSetUp.numberOfSeconds = 600;
            _mjViewController.gameSetUpData = _gameSetUp;
            [_gameSetUp printData];
        } 
        if ([segueIdentifer isEqualToString:@"from20TurnsToGame"]) {
            _gameSetUp.numberOfTurns = 20;
            _mjViewController.gameSetUpData = _gameSetUp;
            [_gameSetUp printData];
        }
        if ([segueIdentifer isEqualToString:@"from50TurnsToGame"]) {
            _gameSetUp.numberOfTurns = 50;
            _mjViewController.gameSetUpData = _gameSetUp;
            [_gameSetUp printData];
        }
        if ([segueIdentifer isEqualToString:@"from100TurnsToGame"]) {
            _gameSetUp.numberOfTurns = 100;
            _mjViewController.gameSetUpData = _gameSetUp;
            [_gameSetUp printData];
        } 
//    }];
    
}

#pragma mark - Tap Methods

-(IBAction)tappedHowManyPlayers:(UIButton *)button {
    if (button.tag == 2) {
        _gameSetUp.numberOfPlayers = 2;
        
    }
    if (button.tag == 3) {
        _gameSetUp.numberOfPlayers = 3;
    }
    if (button.tag == 4) {
        _gameSetUp.numberOfPlayers = 4;
    }
    [UIView animateWithDuration:0.25 animations:^ {
        _twoPlayersButton.hidden = YES;
        _threePlayersButton.hidden = YES;
        _fourPlayersButton.hidden = YES;
        _label.hidden = YES;
    }completion:^(BOOL finished) {
        _label.text = @"What board size do you want?";
        [UIView animateWithDuration:0.25 animations:^ {
            _boardsize20x20.hidden = NO;
            _boardsize30x30.hidden = NO;
            _boardsize50x50.hidden = NO;
            _label.hidden = NO;
        }completion:^(BOOL finished) {
            _boardsize20x20.userInteractionEnabled = YES;
            _boardsize30x30.userInteractionEnabled = YES;
            _boardsize50x50.userInteractionEnabled = YES;
        }];
    }];
}

-(IBAction)tappedboardsize:(UIButton *)button {
    if (button.tag == 20) {
        _gameSetUp.boardSize = CGSizeMake(20, 20);
    }
    if (button.tag == 30) {
        _gameSetUp.boardSize = CGSizeMake(30, 30);
    }
    if (button.tag == 50) {
        _gameSetUp.boardSize = CGSizeMake(50, 50);
    }
    [UIView animateWithDuration:0.25 animations:^ {
        _boardsize20x20.hidden = YES;
        _boardsize30x30.hidden = YES;
        _boardsize50x50.hidden = YES;
        _label.hidden = YES;
    }completion:^(BOOL finished) {
        _boardsize20x20.userInteractionEnabled = NO;
        _boardsize30x30.userInteractionEnabled = NO;
        _boardsize50x50.userInteractionEnabled = NO;
        _label.text = @"What type of game do you want?";
        [UIView animateWithDuration:0.25 animations:^ {
            _timeBasedButton.hidden = NO;
            _turnBasedButton.hidden = NO;
            _label.hidden = NO;
        }completion:^(BOOL finished) {
            _timeBasedButton.userInteractionEnabled = YES;
            _turnBasedButton.userInteractionEnabled = YES;
        }];
    }];
}

-(IBAction)tappedTypeOfGame:(UIButton *)button {
    if (button.tag == 1) {
        _gameSetUp.gameType = [NSString stringWithString:@"timeBased"];
    }
    if (button.tag == 2) {
        _gameSetUp.gameType = [NSString stringWithString:@"turnBased"];
    }

    [UIView animateWithDuration:0.25 animations:^ {
        _timeBasedButton.hidden = YES;
        _turnBasedButton.hidden = YES;
        _label.hidden = YES;
    }completion:^(BOOL finished) {
        _timeBasedButton.userInteractionEnabled = NO;
        _turnBasedButton.userInteractionEnabled = NO;
        if (button.tag == 1) {
            _label.text = @"How many minutes would you like to play for?";
            [UIView animateWithDuration:0.25 animations:^ {
                _twoMinutesButton.hidden = NO;
                _fiveMinutesButton.hidden = NO;
                _tenMinutesButton.hidden = NO;
                _label.hidden = NO;
            }completion:^(BOOL finished) {
                _twoMinutesButton.userInteractionEnabled = YES;
                _fiveMinutesButton.userInteractionEnabled = YES;
                _tenMinutesButton.userInteractionEnabled = YES;
            }];
        }
        if (button.tag == 2) {
            _label.text = @"How many turns would you like to play for?";
            [UIView animateWithDuration:0.25 animations:^ {
                _twentyTurnsButton.hidden = NO;
                _fiftyTurnsButton.hidden = NO;
                _hundredTurnsButton.hidden = NO;
                _label.hidden = NO;
            }completion:^(BOOL finished) {
                _twentyTurnsButton.userInteractionEnabled = YES;
                _fiftyTurnsButton.userInteractionEnabled = YES;
                _hundredTurnsButton.userInteractionEnabled = YES;
            }];
        }
        if (button.tag == 3) {
            _label.text = @"";
        }
    }];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
