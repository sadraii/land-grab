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
@synthesize toolbar = _toolbar;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void) createDebugPieces {
	float height = _toolbar.frame.size.height - (2.0f * 10);
	for (int i = 0; i < 20; i++) {
//		MJPiece* piece = [[MJPiece alloc] initWithFrame:CGRectMake(offset + maxX, offset, height, height)];
		MJPiece* piece = nil;
		
		//		furthestRight += piece.frame.size.width + offset;
		switch (i % 4) {
			case 0:
				piece = [[MJPiece alloc] initWithImage:[UIImage imageNamed:@"Piece_up.png"]];
				break;
			case 1:
				piece = [[MJPiece alloc] initWithImage:[UIImage imageNamed:@"Piece_down.png"]];
				break;
			case 2:
				piece = [[MJPiece alloc] initWithImage:[UIImage imageNamed:@"Piece_left.png"]];
				break;
			case 3:
				piece = [[MJPiece alloc] initWithImage:[UIImage imageNamed:@"Piece_right.png"]];
				break;
				
			default:
				break;
		}
		
		[piece setParentViewController:self];
		[piece setBoard:_board];
		[piece setToolbar:_toolbar];
		
		[piece setDelegate:_toolbar];
		[piece.delegate addPiece:piece];
	}
	
}


#pragma mark - MJPieceDelegate Methods

- (BOOL) addPiece:(MJPiece *)piece {
	NSLog(@"VC: addPiece");
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
	[self createDebugPieces];
}

- (void)viewDidUnload
{
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
