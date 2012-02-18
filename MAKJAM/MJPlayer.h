//
//  MJPlayer.h
//  MAKJAM
//
//  Created by Andrew Huss on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MJPiece;
@class MJViewController;

@interface MJPlayer : NSObject {
	NSInteger score;
}

@property (weak, nonatomic) MJViewController* parentViewController;

@property (strong, nonatomic) NSMutableArray* pieces;
@property (strong, nonatomic) NSString* handle;
@property (readwrite) NSInteger score;

- (NSUInteger) piecesInPlay;

@end
