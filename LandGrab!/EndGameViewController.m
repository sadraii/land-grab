//
//  EndGameViewController.m
//  LandGrab!
//
//  Created by Helen Saenz on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EndGameViewController.h"
#import "EndGameData.h"
#import "MJPlayer.h"

@implementation EndGameViewController
@synthesize PlayerWinLabel = _PlayerWinLabel;
@synthesize Player1Score = _Player1Score;
@synthesize Player2Score = _Player2Score;
@synthesize Player3Score = _Player3Score;
@synthesize Player4Score = _Player4Score;
@synthesize endGameData = _endGameData;
@synthesize players = _players;
@synthesize numberOfPlayers = _numberOfPlayers;


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (IBAction)newGame:(id)sender {
	[[self navigationController] popToRootViewControllerAnimated:YES];
}



-(id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        EndGameData *tmp = [[EndGameData alloc] init];
        _endGameData = tmp;
        
        _players = [[NSMutableArray alloc] init];
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _PlayerWinLabel.alpha = 0.0;
    _Player1Score.alpha = 0.0;
    
    _Player2Score.alpha = 0.0;
   
    _Player3Score.alpha = 0.0;
 
    _Player4Score.alpha = 0.0;
  
    
    [self calculateEndGame];
    
    _PlayerWinLabel.transform = CGAffineTransformMakeScale(5.0, 5.0);
    if (_numberOfPlayers == 2) {
        
        [UIView animateWithDuration:0.75 animations:^ {
            _PlayerWinLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
            _PlayerWinLabel.alpha = 1.0;
        }completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.75 animations:^ {
                _Player1Score.alpha = 1.0; 
            }completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.75 animations:^ {
                    _Player2Score.alpha = 1.0; 
                }];
            }];
        }];
    }
    
    if (_numberOfPlayers == 3) {
        
        [UIView animateWithDuration:0.75 animations:^ {
            _PlayerWinLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
            _PlayerWinLabel.alpha = 1.0;
        }completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.75 animations:^ {
                _Player1Score.alpha = 1.0; 
            }completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.75 animations:^ {
                    _Player2Score.alpha = 1.0; 
                }completion:^(BOOL finished) {
                   
                    [UIView animateWithDuration:0.75 animations:^ {
                        _Player3Score.alpha = 1.0;  
                    }];
                }];
            }];
        }];
    }
    if (_numberOfPlayers == 4) {
        [UIView animateWithDuration:0.75 animations:^ {
            _PlayerWinLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
            _PlayerWinLabel.alpha = 1.0;
        }completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.75 animations:^ {
                _Player1Score.alpha = 1.0; 
            }completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.75 animations:^ {
                    _Player2Score.alpha = 1.0; 
                }completion:^(BOOL finished) {
                   
                    [UIView animateWithDuration:0.75 animations:^ {
                        _Player3Score.alpha = 1.0;  
                    }completion:^(BOOL finished) {
                       
                        [UIView animateWithDuration:0.75 animations:^ {
                            _Player4Score.alpha = 1.0; 
                        }];
                    }];
                }];
            }];
        }];
    }
}

-(void) calculateEndGame {
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"combinedScore"
                                                  ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray  = [_players sortedArrayUsingDescriptors:sortDescriptors];
        
    if (_numberOfPlayers == 2) {
        MJPlayer *firstPlace = [sortedArray objectAtIndex:0];
        MJPlayer *secondPlace = [sortedArray objectAtIndex:1];
        
        NSString *lower1 = [firstPlace.handle lowercaseString];
        
        NSString *lower2 = [secondPlace.handle lowercaseString];
        
         
        _PlayerWinLabel.text = [NSString stringWithFormat:@"%@ won the Game!", firstPlace.handle];
        _Player1Score.text = [NSString stringWithFormat:@"%@: %d", firstPlace.handle, firstPlace.combinedScore];
        
        _Player2Score.text = [NSString stringWithFormat:@"%@: %d", secondPlace.handle, secondPlace.combinedScore];
        _Player3Score.alpha = 0.0;
        _Player4Score.alpha = 0.0;
        if (firstPlace.handle == @"Blue") {
            _PlayerWinLabel.textColor = [UIColor blueColor];
            _Player1Score.textColor = [UIColor blueColor];
            _Player2Score.textColor = [UIColor redColor];
        }
        else {
            _PlayerWinLabel.textColor = [UIColor redColor];
            _Player1Score.textColor = [UIColor redColor];
            _Player2Score.textColor = [UIColor blueColor];
        }
    }
    if (_numberOfPlayers == 3) {
        MJPlayer *firstPlace = [sortedArray objectAtIndex:0];
        MJPlayer *secondPlace = [sortedArray objectAtIndex:1];
        MJPlayer *thirdPlace = [sortedArray objectAtIndex:2];
        _PlayerWinLabel.text = [NSString stringWithFormat:@"%@ won the Game!", firstPlace.handle];
        _Player1Score.text = [NSString stringWithFormat:@"%@: %d", firstPlace.handle, firstPlace.combinedScore];
        _Player2Score.text = [NSString stringWithFormat:@"%@: %d", secondPlace.handle,secondPlace.combinedScore];
        _Player3Score.text = [NSString stringWithFormat:@"%@: %d", thirdPlace.handle, thirdPlace.combinedScore];
        _Player4Score.alpha = 0.0;
        
        if (firstPlace.handle == @"Blue") {
            _PlayerWinLabel.textColor = [UIColor blueColor];
            
            _Player1Score.textColor = [UIColor blueColor];
            if (secondPlace.handle == @"Red") {
                _Player2Score.textColor = [UIColor redColor];
                _Player3Score.textColor = [UIColor greenColor];
            }
            if (secondPlace.handle == @"Green") {
                _Player2Score.textColor = [UIColor greenColor];
                _Player3Score.textColor = [UIColor redColor];
            }
        }
        else if(firstPlace.handle == @"Red") {
             _PlayerWinLabel.textColor = [UIColor redColor];
        }
        else {
            _PlayerWinLabel.textColor = [UIColor greenColor];
        }
    }
    if (_numberOfPlayers == 4) {
        MJPlayer *firstPlace = [sortedArray objectAtIndex:0];
        MJPlayer *secondPlace = [sortedArray objectAtIndex:1];
        MJPlayer *thirdPlace = [sortedArray objectAtIndex:2];
        MJPlayer *forthPlace = [sortedArray objectAtIndex:3];
        _PlayerWinLabel.text = [NSString stringWithFormat:@"%@ won the Game!", firstPlace.handle];
        _Player1Score.text = [NSString stringWithFormat:@"%@: %d", firstPlace.handle, firstPlace.combinedScore];
        _Player2Score.text = [NSString stringWithFormat:@"%@: %d", secondPlace.handle, secondPlace.combinedScore];
        _Player3Score.text = [NSString stringWithFormat:@"%@: %d", thirdPlace.handle, thirdPlace.combinedScore];
        _Player4Score.text = [NSString stringWithFormat:@"%@: %d", forthPlace.handle, forthPlace.combinedScore];
        if (firstPlace.handle == @"Blue") {
            _PlayerWinLabel.textColor = [UIColor blueColor];
            
        }
        else if(firstPlace.handle == @"Red") {
            _PlayerWinLabel.textColor = [UIColor redColor];
        }
        else if(firstPlace.handle == @"Green") {
            _PlayerWinLabel.textColor = [UIColor greenColor];
        }
        else {
            _PlayerWinLabel.textColor = [UIColor yellowColor];
        }
    }
}

- (void)viewDidUnload
{
    [self setPlayerWinLabel:nil];
    [self setPlayer1Score:nil];
    [self setPlayer2Score:nil];
    [self setPlayer3Score:nil];
    [self setPlayer4Score:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
