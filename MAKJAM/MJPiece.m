//
//  MJPiece.m
//  MAKJAM
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJPiece.h"
#import "MJTile.h"
#import "MJViewController.h"
#import "MJPlayer.h"

@implementation MJPiece

@synthesize delegate = _delegate;
@synthesize viewController = _viewController;
@synthesize superview = _superview;
@synthesize player = _player;

@synthesize size = _size;
@synthesize tiles = _tiles;
@synthesize rotation = _rotation;
@synthesize image = _image;
@synthesize name = _name;
@synthesize isPlayed = _isPlayed;

-(id) init {
    if ((self = [super init]) == nil) {
		return self;
    }
	origin = CGPointZero;
	size = CGSizeZero;
	_tiles = [[NSMutableArray alloc] init];
	_rotation = 0;
	_image = nil;
	_name = nil;
    return self;
}

#pragma mark - Class Methods

- (void) setOrigin:(CGPoint)point {
	CGSize distance = CGSizeMake(point.x - origin.x, point.y - origin.x);
	[self moveTiles:distance];
}

- (CGPoint) origin {
	return origin;
}

- (void) moveTiles:(CGSize)distance {
	for (MJTile* t in _tiles) {
		origin = CGPointMake(t.frame.origin.x + distance.width, t.frame.origin.y + distance.height);
		[t setFrame:CGRectMake(origin.x, origin.y, t.frame.size.width, t.frame.size.height)];
	}
}

- (void) snapToPoint {
	CGSize distance = CGSizeZero;
	int offX = (int)origin.x % [MJTile tileSize];
	int offY = (int)origin.y % [MJTile tileSize];
	if ((offX / ((CGFloat)[MJTile tileSize] - 1)) > 0.5f) {
		distance.width += ([MJTile tileSize] - offX);
	}
	else {
		distance.width -= offX;
	}
	if ((offY / ((CGFloat)[MJTile tileSize] - 1)) > 0.5f) {
		distance.height += ([MJTile tileSize] - offY);
	}
	else {
		distance.height -= offY;
	}
	
	[self moveTiles:distance];
}

- (void) addAsSubviewToView:(UIView*)view {
	for (MJTile* t in _tiles) {
		[view addSubview:t];
		NSLog(@"Adding tile at point: (%f, %f)", t.frame.origin.x, t.frame.origin.y);
	}
	[self setSuperview:view];
}

- (void) removeFromSuperview {
	for (MJTile* t in _tiles) {
		NSLog(@"Removing Tile From Superview");
		[t removeFromSuperview];
	}
	[self setSuperview:nil];
}

- (void) loadDefaultTiles {
	MJTile* tile = [[MJTile alloc] initWithCoordinate:CGPointMake(0, 0)];
	[tile setPiece:self];
	[tile setDelegate:self];
	[self addTile:tile];
	
}
- (void) addTile:(MJTile*)tile {
	if (tile.frame.size.width > size.width) {
		size.width = tile.frame.size.width;
	}
	if (tile.frame.size.height > size.height) {
		size.height = tile.frame.size.height;
	}
	
	[_tiles addObject:tile];
}

- (void) revertToStartingSize {
	for (MJTile* t in _tiles) {
		CGPoint startingOrigin = t.frame.origin;
		CGSize startingSize = t.frame.size;
		CGPoint coordinate = CGPointMake(startingOrigin.x / startingSize.width, startingOrigin.y / startingSize.height);
		
		CGPoint newOrigin = CGPointMake(coordinate.x * [MJTile tileSize], coordinate.y * [MJTile tileSize]);
		CGSize newSize = CGSizeMake([MJTile tileSize], [MJTile tileSize]);
		t.frame = CGRectMake(newOrigin.x, newOrigin.y, newSize.width, newSize.height);
	}
}

- (void) setScale:(CGFloat)scale {
	for (MJTile* t in _tiles) {
		CGPoint startingOrigin = t.frame.origin;
		CGSize startingSize = t.frame.size;
		CGPoint coordinate = CGPointMake(startingOrigin.x / startingSize.width, startingOrigin.y / startingSize.height);
		
		CGPoint newOrigin = CGPointMake(coordinate.x * [MJTile tileSize], coordinate.y * [MJTile tileSize]);
		CGSize newSize = CGSizeMake([MJTile tileSize], [MJTile tileSize]);
		t.frame = CGRectMake(newOrigin.x, newOrigin.y, newSize.width, newSize.height);
	}
}

#pragma mark - MJTileDelegate Methods
- (void) touchesBegan:(CGPoint)point {
	[_viewController addPiece:self];
	//Highlight piece
}
- (void) touchesMoved:(CGSize)distance {
	[self moveTiles:distance];
}
- (void) touchesEnded:(CGPoint)point {
	[_delegate snapToPoint];
}
- (void) touchesCanceled: (CGSize)distanceTraveled {
	[self moveTiles:CGSizeMake(distanceTraveled.width * -1, distanceTraveled.height * -1)];
}


@end
