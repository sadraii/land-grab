//
//  MJRootViewController.m
//  MAKJAM
//
//  Created by Andrew Huss on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJRootViewController.h"

@implementation MJRootViewController

@synthesize eaglView = _eaglView;
@synthesize scrollView = _scrollView;

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


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
	[super loadView];
	NSLog(@"Load View");
	int toolbarHeight = 100;
	_scrollView = [[MJToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - toolbarHeight, self.view.bounds.size.width, toolbarHeight)];
	[_scrollView setToolbarHeight:toolbarHeight];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	if (_eaglView) {
		[self.view addSubview:_eaglView];
		NSLog(@"Added EAGLView");
	}
	if (_scrollView) {
		[_scrollView createDebugPieces];
		[self.view addSubview:_scrollView];
		NSLog(@"Added ScrollView");
	}
	NSLog(@"View Did Load");
}


- (void)viewDidUnload
{
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
