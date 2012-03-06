//
//  MainMenu.m
//  LandGrab!
//
//  Created by Helen Saenz on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenu.h"

@implementation MainMenu
@synthesize numberOfPlayers;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
  
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Tap Methods


-(IBAction)tappedNewGame:(id)sender {
    NSLog(@"Hi Friend");
}

-(IBAction)tappedTwoPlayers:(id)sender {
    numberOfPlayers = 2;
    
    NSLog(@"Number of players %d",numberOfPlayers);
}

-(IBAction)tappedThreePlayers:(id)sender {
    numberOfPlayers = 3;
    NSLog(@"Number of players %d",numberOfPlayers);
}

-(IBAction)tappedFourPlayers:(id)sender {
    numberOfPlayers = 4;
    NSLog(@"Number of players %d",numberOfPlayers);
}

-(IBAction)tappedTimeBased:(id)sender {
    
}

-(IBAction)tappedTurnBased:(id)sender {
    
}

-(IBAction)tappedUnlimtedBased:(id)sender {
    
}
-(IBAction)tappedTwoMinutes:(id)sender {
    
}

-(IBAction)tappedFiveMinutes:(id)sender {
    
}

-(IBAction)tappedTenMinutes:(id)sender {
    
}

-(IBAction)tappedTwentyTurns:(id)sender {
    
}

-(IBAction)tappedFiftyTurns:(id)sender {
    
}

-(IBAction)tappedHundredTurns:(id)sender {
   [[NSNotificationCenter defaultCenter] postNotificationName:@"addTwoPlayers" object:nil]; 
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
