/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim. 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "AppDelegate.h"
#import "MJRootViewController.h"

@implementation AppDelegate

-(void) initializationComplete
{
#ifdef KK_ARC_ENABLED
	CCLOG(@"ARC is enabled");
#else
	CCLOG(@"ARC is either not available or not enabled");
#endif
}

-(id) alternateRootViewController
{
	MJRootViewController* rvc = [[MJRootViewController alloc] init];
	[rvc setEaglView:[[CCDirector sharedDirector] openGLView]];
	NSLog(@"Alternate Root View Controller");
	return rvc;
}

-(id) alternateView
{
	return nil;
}

@end
