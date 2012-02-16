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
@synthesize toolbar = _toolbar;
@synthesize rotateButton = _rotateButton;

-(id) initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder]) == nil) {
		return self;
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)resetButtonPressed:(id)sender {
	[_toolbar clearToolbar];
	[_board clearBoard];
	//@"up_left", @"up_right", @"left_down", @"left_up", @"right_down", @"right_up", 
	NSArray* pieceNames = [[NSArray alloc] initWithObjects:@"Cross", @"down_left", @"down_right", @"H", @"U", @"vertical", @"W", nil];
	//	float height = _toolbar.frame.size.height - (2.0f * 10);
	int diffPieces = [pieceNames count];
	int numPieces = diffPieces;
	for (int i = 0; i < numPieces; i++) {
		MJPiece* piece = [[MJPiece alloc] initWithImage:[UIImage imageNamed:[pieceNames objectAtIndex:i % diffPieces]]];
		
		[piece setParentViewController:self];
		[piece setBoard:_board];
		[piece setToolbar:_toolbar];
		
		[piece setDelegate:_toolbar];
		[piece.delegate addPiece:piece];
	}
	int boardWidth = 27;
	int boardHeight = 27;
	[_board setBoardSize:CGSizeMake(boardWidth, boardHeight)];
}

#pragma mark - MJPieceDelegate Methods

- (BOOL) addPiece:(MJPiece *)piece {
	//need to animate this!!!!!!!!
	if (![piece.superview isEqual:_board]) {
		[_board scalePiece:piece];//Scales the piece to the current board zoom scale
	}
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
	[self resetButtonPressed:self];
}

- (void)viewDidUnload
{
	[self setTopToolbar:nil];
	[self setResetButton:nil];
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