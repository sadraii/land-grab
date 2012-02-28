//
//  MJPlayer.h
//  LandGrab!
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MJViewController;
@class MJBoard;
@class MJToolbar;

@class MJPiece;


@interface MJPlayer : NSObject {
	
}

@property (weak, nonatomic) MJViewController* viewController;
@property (weak, nonatomic) MJBoard* board;
@property (weak, nonatomic) MJToolbar* toolbar;

@property (strong, nonatomic) NSMutableArray* pieces;
@property (strong, nonatomic) NSString* handle;
@property (strong, nonatomic) UIColor* color;
@property (readwrite, nonatomic) NSUInteger score;
@property (readwrite, nonatomic) NSUInteger money;



//- (void) loadDebugPieces;

@end
