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
@synthesize unlimtedBasedButton = _unlimtedBasedButton;
@synthesize twoMinutesButton = _twoMinutesButton;
@synthesize fiveMinutesButton = _fiveMinutesButton;
@synthesize tenMinutesButton = _tenMinutesButton;
@synthesize twentyTurnsButton = _twentyTurnsButton;
@synthesize fiftyTurnsButton = _fiftyTurnsButton;
@synthesize hundredTurnsButton = _hundredTurnsButton;
@synthesize label = _label;

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
 
    _twoPlayersButton.alpha = 0.0;
    _twoPlayersButton.userInteractionEnabled = NO;
    _threePlayersButton.alpha = 0.0;
    _threePlayersButton.userInteractionEnabled = NO;
    _fourPlayersButton.alpha = 0.0;
    _fourPlayersButton.userInteractionEnabled = NO;
    _timeBasedButton.alpha = 0.0;
    _timeBasedButton.userInteractionEnabled = NO;
    _turnBasedButton.alpha = 0.0;
    _turnBasedButton.userInteractionEnabled = NO;
    _unlimtedBasedButton.alpha = 0.0;
    _unlimtedBasedButton.userInteractionEnabled = NO;
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
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
  
    [self setTwoPlayersButton:nil];
    [self setThreePlayersButton:nil];
    [self setFourPlayersButton:nil];
    [self setTimeBasedButton:nil];
    [self setTurnBasedButton:nil];
    [self setUnlimtedBasedButton:nil];
    [self setTwoMinutesButton:nil];
    [self setFiveMinutesButton:nil];
    [self setTenMinutesButton:nil];
    [self setTwentyTurnsButton:nil];
    [self setFiftyTurnsButton:nil];
    [self setHundredTurnsButton:nil];
    [self setStartNewGame:nil];
    [self setLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueIdentifer = [segue identifier];
    
    _mjViewController = [segue destinationViewController]; 
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
}

#pragma mark - Tap Methods


-(IBAction)tappedNewGame:(id)sender {
    NSLog(@"Hi Friend, welcome to the new game!");

    [UIView animateWithDuration:0.25 animations:^ {
        _startNewGame.alpha = 0.0;
        _label.alpha = 0.0;
    }completion:^(BOOL finished) {
        _startNewGame.userInteractionEnabled = NO;
        _label.text = @"How many Players?";
        [UIView animateWithDuration:0.25 animations:^ {
            _twoPlayersButton.alpha = 1.0;
            _threePlayersButton.alpha = 1.0;
            _fourPlayersButton.alpha = 1.0;
            _label.alpha = 1.0;
        }completion:^(BOOL finished) {
            _twoPlayersButton.userInteractionEnabled = YES;
            _threePlayersButton.userInteractionEnabled = YES;
            _fourPlayersButton.userInteractionEnabled = YES;
        }];
    }];
}

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
        _label.text = @"What Kind of Game Play would you like?";
        [UIView animateWithDuration:0.25 animations:^ {
            _timeBasedButton.alpha = 1.0;
            _turnBasedButton.alpha = 1.0;
            _unlimtedBasedButton.alpha = 1.0;
            _label.alpha = 1.0;
        }completion:^(BOOL finished) {
            _timeBasedButton.userInteractionEnabled = YES;
            _turnBasedButton.userInteractionEnabled = YES;
            _unlimtedBasedButton.userInteractionEnabled = YES;
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
    if (button.tag == 3) {
        _gameSetUp.gameType = [NSString stringWithString:@"unlimitedBased"];
    }

    [UIView animateWithDuration:0.25 animations:^ {
        _timeBasedButton.alpha = 0.0;
        _turnBasedButton.alpha = 0.0;
        _unlimtedBasedButton.alpha = 0.0;
        _label.alpha = 0.0;
    }completion:^(BOOL finished) {
        _timeBasedButton.userInteractionEnabled = NO;
        _turnBasedButton.userInteractionEnabled = NO;
        _unlimtedBasedButton.userInteractionEnabled = NO;
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
