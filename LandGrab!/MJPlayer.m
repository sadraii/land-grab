//
//  MJPlayer.m
//  LandGrab!
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJPlayer.h"

#import "MJViewController.h"
#import "MJBoard.h"
#import "MJToolbar.h"

#import "MJPiece.h"

@implementation MJPlayer

@synthesize viewController = _viewController;
@synthesize board = _board;
@synthesize toolbar = _toolbar;

@synthesize pieces = _pieces;
-(id) init {
    if ((self = [super init]) == nil) {
		return self;
    }
	_pieces = nil;
    return self;
}

- (void) loadDebugPieces {
	if (!_pieces) _pieces = [[NSMutableArray alloc] init];
	for (int i = 0; i < 5; i++) {
		NSLog(@"Creating piece");
		MJPiece* p = [[MJPiece alloc] init];
		[p setDelegate:_toolbar];
		[p setViewController:_viewController];
		[p setBoard:_board];
		[p setToolbar:_toolbar];
		[p loadDebugTiles];
		[_pieces addObject:p];
	}
}

@end
