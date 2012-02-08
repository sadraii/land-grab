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
		MJPiece* piece = [[MJPiece alloc] initWithFrame:CGRectMake(0, 0, height, height)];
		//		furthestRight += piece.frame.size.width + offset;
		switch (i % 5) {
			case 0:
				[piece setBackgroundColor:[UIColor darkGrayColor]];
				break;
			case 1:
				[piece setBackgroundColor:[UIColor whiteColor]];
				break;
			case 2:
				[piece setBackgroundColor:[UIColor lightGrayColor]];
				break;
			case 3:
				[piece setBackgroundColor:[UIColor blackColor]];
				break;
			case 4:
				[piece setBackgroundColor:[UIColor lightTextColor]];
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
