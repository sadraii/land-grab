//
//  GCHelper.h
//  MAKJAM
//
//  Created by Andrew Huss on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GCHelper : NSObject {
	BOOL gameCenterAvailable;
	BOOL userAuthenticated;
}

@property (readonly) BOOL gameCenterAvailable;

+ (GCHelper *)sharedInstance;
- (void)authenticateLocalUser;

@end
