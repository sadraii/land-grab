//
//  GCHelper.m
//  MAKJAM
//
//  Created by Andrew Huss on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GCHelper.h"

@implementation GCHelper

@synthesize gameCenterAvailable = _gameCenterAvailable;

#pragma mark - Initialization

static GCHelper* sharedHelper = nil;
+ (GCHelper*) sharedInstance {
	if (!sharedHelper) {
		sharedHelper = [[GCHelper alloc] init];
	}
	return sharedHelper;
}

- (BOOL) isGameCenterAvailable {
	Class gcClass = NSClassFromString(@"GKLocalPlayer");
	
	NSString* reqSysVer = @"4.1";
	NSString* currSysVer = [[UIDevice currentDevice] systemVersion];
	BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
	return (gcClass && osVersionSupported);
}

-(id) init {
    if ((self = [super init]) == nil) {
		return self;
    }
    gameCenterAvailable = [self isGameCenterAvailable];
	if (gameCenterAvailable) {
		NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
		[nc addObserver:self 
			   selector:@selector(authenticationChanged) 
				   name:GKPlayerAuthenticationDidChangeNotificationName 
				 object:nil];
	}
    return self;
}

- (void) authenticationChanged {
	if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
		NSLog(@"Authentication changed: player authenticated");
		userAuthenticated = YES;
	}
	else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
		NSLog(@"Authentication changed: player not authenticated");
		userAuthenticated = NO;
	}
}

- (void) authenticateLocalUser {
	if (!gameCenterAvailable) return;
	
	NSLog(@"Local User: authenticating");
	if ([GKLocalPlayer localPlayer].authenticated == NO) {
		[[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];
	}
	else {
		NSLog(@"Local User: already authenticated");
	}
}

@end
