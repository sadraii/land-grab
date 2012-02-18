//
//  GCHelper.h
//  MAKJAM
//
//  Created by Andrew Huss on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@protocol GCHelperDelegate 
- (void)matchStarted;
- (void)matchEnded;
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data 
   fromPlayer:(NSString *)playerID;
@end

@interface GCHelper : NSObject <GKMatchmakerViewControllerDelegate, GKMatchDelegate> {
	BOOL gameCenterAvailable;
	BOOL userAuthenticated;
	
	UIViewController *presentingViewController;
	GKMatch *match;
	BOOL matchStarted;
	id <GCHelperDelegate> delegate;
	
	NSMutableDictionary* playersDict;
}

@property (readonly) BOOL gameCenterAvailable;

@property (strong, nonatomic) UIViewController *presentingViewController;
@property (strong, nonatomic) GKMatch *match;
@property (strong, nonatomic) id <GCHelperDelegate> delegate;

@property (strong, nonatomic) NSMutableDictionary* playersDict;

+ (GCHelper *)sharedInstance;
- (void)authenticateLocalUser;

- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers viewController:(UIViewController *)viewController delegate:(id<GCHelperDelegate>)theDelegate;

@end
