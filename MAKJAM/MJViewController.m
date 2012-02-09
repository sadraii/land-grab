//
//  MJViewController.m
//  MAKJAM
//
//  Created by Andrew Huss on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJViewController.h"
#import "MJPiece.h"

@implementation MJViewController

@synthesize board = _board;
@synthesize topToolbar = _topToolbar;
@synthesize resetButton = _resetButton;
@synthesize addButton = _addButton;
@synthesize toolbar = _toolbar;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)addButtonPressed:(id)sender {
}

- (IBAction)resetButtonPressed:(id)sender {
	[_toolbar clearToolbar];
	[_board clearBoard];
	NSArray* pieceNames = [[NSArray alloc] initWithObjects:@"down_left", @"down_right", @"up_left", @"up_right", @"left_down", @"left_up", @"right_down", @"right_up", nil];
	//	float height = _toolbar.frame.size.height - (2.0f * 10);
	int diffPieces = [pieceNames count];
	int numPieces = diffPieces * 3;
	for (int i = 0; i < numPieces; i++) {
		MJPiece* piece = [[MJPiece alloc] initWithImage:[UIImage imageNamed:[pieceNames objectAtIndex:i % diffPieces]]];
		
		[piece setParentViewController:self];
		[piece setBoard:_board];
		[piece setToolbar:_toolbar];
		
		[piece setDelegate:_toolbar];
		[piece.delegate addPiece:piece];
	}
	int boardSize = 25;
	[_board setBoardSize:CGSizeMake(boardSize, boardSize)];
}


#pragma mark - MJPieceDelegate Methods

- (BOOL) addPiece:(MJPiece *)piece {
	NSLog(@"VC: addPiece");
	[piece revertToStartingSize];
	[self.view addSubview:piece];
	return YES;
}

- (BOOL) removePiece:(MJPiece *)piece {
	if ([self isEqual:piece.superview]) {
		[piece removeFromSuperview];
		return YES;
	}
	return NO;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
//	[self createDebugPieces];
}

- (void)viewDidUnload
{
	[self setTopToolbar:nil];
	[self setResetButton:nil];
	[self setAddButton:nil];
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
	return YES;
}

@end
