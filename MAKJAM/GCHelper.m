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
@synthesize presentingViewController;
@synthesize match;
@synthesize delegate;
@synthesize playersDict;

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

// Add new method after authenticationChanged
- (void)lookupPlayers {
	
    NSLog(@"Looking up %d players...", match.playerIDs.count);
    [GKPlayer loadPlayersForIdentifiers:match.playerIDs withCompletionHandler:^(NSArray *players, NSError *error) {
		
        if (error != nil) {
            NSLog(@"Error retrieving player info: %@", error.localizedDescription);
            matchStarted = NO;
            [delegate matchEnded];
        } else {
			
            // Populate players dict
            self.playersDict = [NSMutableDictionary dictionaryWithCapacity:players.count];
            for (GKPlayer *player in players) {
                NSLog(@"Found player: %@", player.alias);
                [playersDict setObject:player forKey:player.playerID];
            }
			
            // Notify delegate match can begin
            matchStarted = YES;
            [delegate matchStarted];
			
        }
    }];
	
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

- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers   
				 viewController:(UIViewController *)viewController 
					   delegate:(id<GCHelperDelegate>)theDelegate {
	
    if (!gameCenterAvailable) return;
	
    matchStarted = NO;
    self.match = nil;
    self.presentingViewController = viewController;
    delegate = theDelegate;               
    [presentingViewController dismissModalViewControllerAnimated:NO];
	
    GKMatchRequest *request = [[GKMatchRequest alloc] init]; 
    request.minPlayers = minPlayers;     
    request.maxPlayers = maxPlayers;
	
    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];    
    mmvc.matchmakerDelegate = self;
	
    [presentingViewController presentModalViewController:mmvc animated:YES];
	
}

#pragma mark - GKMatchmakerViewControllerDelegate

// The user has cancelled matchmaking
- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController {
    [presentingViewController dismissModalViewControllerAnimated:YES];
}

// Matchmaking has failed with an error
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    [presentingViewController dismissModalViewControllerAnimated:YES];
    NSLog(@"Error finding match: %@", error.localizedDescription);    
}

// A peer-to-peer match has been found, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)theMatch {
    [presentingViewController dismissModalViewControllerAnimated:YES];
    self.match = theMatch;
    match.delegate = self;
    if (!matchStarted && match.expectedPlayerCount == 0) {
        NSLog(@"Ready to start match!");
		[self lookupPlayers];
    }
}

#pragma mark - GKMatchDelegate

// The match received data sent from the player.
- (void)match:(GKMatch *)theMatch didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {    
    if (match != theMatch) return;
	
    [delegate match:theMatch didReceiveData:data fromPlayer:playerID];
}

// The player state changed (eg. connected or disconnected)
- (void)match:(GKMatch *)theMatch player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state {   
    if (match != theMatch) return;
	
    switch (state) {
        case GKPlayerStateConnected: 
            // handle a new player connection.
            NSLog(@"Player connected!");
			
            if (!matchStarted && theMatch.expectedPlayerCount == 0) {
                NSLog(@"Ready to start match!");
				[self lookupPlayers];
            }
			
            break; 
        case GKPlayerStateDisconnected:
            // a player just disconnected. 
            NSLog(@"Player disconnected!");
            matchStarted = NO;
            [delegate matchEnded];
            break;
    }                     
}

// The match was unable to connect with the player due to an error.
- (void)match:(GKMatch *)theMatch connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error {
	
    if (match != theMatch) return;
	
    NSLog(@"Failed to connect to player with error: %@", error.localizedDescription);
    matchStarted = NO;
    [delegate matchEnded];
}

// The match was unable to be established with any players due to an error.
- (void)match:(GKMatch *)theMatch didFailWithError:(NSError *)error {
	
    if (match != theMatch) return;
	
    NSLog(@"Match failed with error: %@", error.localizedDescription);
    matchStarted = NO;
    [delegate matchEnded];
}

@end
