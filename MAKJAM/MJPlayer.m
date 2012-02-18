//
//  MJPlayer.m
//  MAKJAM
//
//  Created by Andrew Huss on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJPlayer.h"
#import "MJPiece.h"

@implementation MJPlayer
@synthesize parentViewController = _parentViewController;
@synthesize pieces = _pieces;
@synthesize handle = _handle;
@synthesize score = _score;

-(id) init {
    if ((self = [super init]) == nil) {
		return self;
    }
	_handle = @"Unknown";
    _score = 0;
	_pieces = [[NSMutableArray alloc] init];
    return self;
}

- (NSUInteger) piecesInPlay {
	NSUInteger n = 0;
	for (MJPiece* p in _pieces) {
		if (p.played) {
			n++;
		}
		else {
			NSLog(@"Piece Not in play");
		}
	}
	return n;
}

@end
