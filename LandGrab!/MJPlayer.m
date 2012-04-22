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
#import "MJTile.h"

@implementation MJPlayer

@synthesize viewController = _viewController;
@synthesize board = _board;
@synthesize toolbar = _toolbar;

@synthesize pieces = _pieces;
@synthesize playedPieces = _playedPieces;
@synthesize toolBarPieces = _toolBarPieces;
@synthesize lastPlayedTile = _lastPlayedTile;
@synthesize handle = _handle;
@synthesize color = _color;
@synthesize imageColor = _imageColor;
@synthesize capital = _capital;
@synthesize score = _score;
@synthesize territory = _territory;
@synthesize money = _money;
@synthesize combinedScore = _combinedScore;
@synthesize numberOfTilesToPlay = _numberOfTilesToPlay;
@synthesize numberOfBombsToPlay = _numberOfBombsToPlay;
@synthesize playedBomb = _playedBomb;

-(id) init {
    if ((self = [super init]) == nil) {
		return self;
    }
	_pieces = nil;
	_handle = nil;
	_color = nil;
	_money = 0;
	_score = 0;
	_territory = 0;
    _combinedScore = 0;
    _numberOfTilesToPlay = 0;
    _numberOfBombsToPlay = 0;
	_capital = nil;
	_playedPieces = [[NSMutableArray alloc] init];
    _toolBarPieces = [[NSMutableArray alloc] init];
	
    return self;
}

- (void) updateScore {
	[self updateTerritory];
	[_viewController.territory setText:[NSString stringWithFormat:@"%i",self.territory]];
    int score = 0;
    if (self.score == 0) {
        score = self.territory;
    }
    else if (self.score < 0) {
        score = self.score + self.territory;
    }
    else {
        score = self.score * self.territory;
    }
	[_viewController.score setText:[NSString stringWithFormat:@"%i",score]];
}

- (void) updateTerritory {
	_territory = 0;
	for (MJTile* t in _playedPieces) {
		t.tag = 0;
	}
	[self updateTerritoryStartingAtCoordinate:_capital.coordinate];
}

- (void) updateTerritoryStartingAtCoordinate:(CGPoint)point {
	CGPoint up = CGPointMake(point.x, point.y + 1);
	CGPoint down = CGPointMake(point.x, point.y - 1);
	CGPoint left = CGPointMake(point.x - 1, point.y);
	CGPoint right = CGPointMake(point.x + 1, point.y);
	MJTile* tmp = nil;
	if ((tmp = [_board tileAtCoordinate:up]) && [tmp.player isEqual:self] && tmp.tag == 0) {
		[tmp setTag:1];
		_territory++;
		[self updateTerritoryStartingAtCoordinate:up];
	}
	if ((tmp = [_board tileAtCoordinate:down]) && [tmp.player isEqual:self] && tmp.tag == 0) {
		[tmp setTag:1];
		_territory++;
		[self updateTerritoryStartingAtCoordinate:down];
	}
	if ((tmp = [_board tileAtCoordinate:left]) && [tmp.player isEqual:self] && tmp.tag == 0) {
		[tmp setTag:1];
		_territory++;
		[self updateTerritoryStartingAtCoordinate:left];
	}
	if ((tmp = [_board tileAtCoordinate:right]) && [tmp.player isEqual:self] && tmp.tag == 0) {
		[tmp setTag:1];
		_territory++;
		[self updateTerritoryStartingAtCoordinate:right];
	}
    //	tmp = [_board tileAtCoordinate:point];
    //	tmp.tag = 0;
}

-(void)updateNumberOfTilesToPlayWithNumber:(NSUInteger)number {
    _numberOfTilesToPlay += number;
    [_toolbar updateCounterWith:_numberOfTilesToPlay];
}

-(void) subtractTile {
    _numberOfTilesToPlay--;
    [_toolbar updateCounterWith:_numberOfTilesToPlay];
}

- (void) updateNumberOfBombsToPlayWithNumber:(NSUInteger)number {
    _numberOfBombsToPlay += number;
    [_toolbar updateBombCounterForPlayer:self];
}

- (void) subtractBomb {
    _numberOfBombsToPlay--;
    [_toolbar updateBombCounterForPlayer:self];
}

- (BOOL) coordinate:(CGPoint)a TouchesCoordinate:(CGPoint)b {
	if (b.x == a.x && (b.y == a.y+1 || b.y == a.y-1)) {
		return YES;
	}
	else if (b.y == a.y && (b.x == a.x+1 || b.x == a.x-1)) {
		return YES;
	}
	return NO;
}

@end
