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

- (void)viewDidLoad
{
    [super viewDidLoad];

    MJViewController *mjVC = [[MJViewController alloc] initWithCoder:nil];
    _mjViewController = mjVC;
    
    GameSetUpData *tmp = [[GameSetUpData alloc] init];
    _gameSetUp = tmp;
    
    _timeBasedButton.alpha = 0.0;
    _timeBasedButton.userInteractionEnabled = NO;
    _turnBasedButton.alpha = 0.0;
    _turnBasedButton.userInteractionEnabled = NO;
    _twoMinutesButton.alpha = 0.0;
    _twoMinutesButton.userInteractionEnabled = NO;
    _fiveMinutesButton.alpha = 0.0;
    _fiveMinutesButton.userInteractionEnabled = NO;
    _tenMinutesButton.alpha = 0.0;
    _tenMinutesButton.userInteractionEnabled = NO;
    _twentyTurnsButton.alpha = 0.0;
    _twentyTurnsButton.userInteractionEnabled = NO;
    _fiftyTurnsButton.alpha = 0.0;
    _fiftyTurnsButton.userInteractionEnabled = NO;
    _hundredTurnsButton.alpha = 0.0;
    _hundredTurnsButton.userInteractionEnabled = NO;
    _boardsize20x20.alpha = 0.0;
    _boardsize20x20.userInteractionEnabled =NO;
    _boardsize30x30.alpha = 0.0;
    _boardsize30x30.userInteractionEnabled =NO;
    _boardsize50x50.alpha = 0.0;
    _boardsize50x50.userInteractionEnabled =NO;
    
    // Do any additional setup after loading the view from its nib.
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
//        self.view.alpha = 0.0;
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
        _twoPlayersButton.alpha = 0.0;
        _threePlayersButton.alpha = 0.0;
        _fourPlayersButton.alpha = 0.0;
        _label.alpha = 0.0;
    }completion:^(BOOL finished) {
        _twoPlayersButton.userInteractionEnabled = NO;
        _threePlayersButton.userInteractionEnabled = NO;
        _fourPlayersButton.userInteractionEnabled = NO;
        _label.text = @"What board size do you want?";
        [UIView animateWithDuration:0.25 animations:^ {
            _boardsize20x20.alpha = 1.0;
            _boardsize30x30.alpha = 1.0;
            _boardsize50x50.alpha = 1.0;
            _label.alpha = 1.0;
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
        _boardsize20x20.alpha = 0.0;
        _boardsize30x30.alpha = 0.0;
        _boardsize50x50.alpha = 0.0;
        _label.alpha = 0.0;
    }completion:^(BOOL finished) {
        _boardsize20x20.userInteractionEnabled = NO;
        _boardsize30x30.userInteractionEnabled = NO;
        _boardsize50x50.userInteractionEnabled = NO;
        _label.text = @"What type of game do you want?";
        [UIView animateWithDuration:0.25 animations:^ {
            _timeBasedButton.alpha = 1.0;
            _turnBasedButton.alpha = 1.0;
            _label.alpha = 1.0;
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
        _timeBasedButton.alpha = 0.0;
        _turnBasedButton.alpha = 0.0;
        _label.alpha = 0.0;
    }completion:^(BOOL finished) {
        _timeBasedButton.userInteractionEnabled = NO;
        _turnBasedButton.userInteractionEnabled = NO;
        if (button.tag == 1) {
            _label.text = @"How many minutes would you like to play for?";
            [UIView animateWithDuration:0.25 animations:^ {
                _twoMinutesButton.alpha = 1.0;
                _fiveMinutesButton.alpha = 1.0;
                _tenMinutesButton.alpha = 1.0;
                _label.alpha = 1.0;
            }completion:^(BOOL finished) {
                _twoMinutesButton.userInteractionEnabled = YES;
                _fiveMinutesButton.userInteractionEnabled = YES;
                _tenMinutesButton.userInteractionEnabled = YES;
            }];
        }
        if (button.tag == 2) {
            _label.text = @"How many turns would you like to play for?";
            [UIView animateWithDuration:0.25 animations:^ {
                _twentyTurnsButton.alpha = 1.0;
                _fiftyTurnsButton.alpha = 1.0;
                _hundredTurnsButton.alpha = 1.0;
                _label.alpha = 1.0;
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
