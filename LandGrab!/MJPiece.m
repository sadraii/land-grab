//
//  MJPiece.m
//  LandGrab!
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJPiece.h"
#import "MJTile.h"
#import "MJViewController.h"
#import "MJPlayer.h"
#import "MJBoard.h"
#import "MJToolbar.h"

@implementation MJPiece

@synthesize delegate = _delegate;
@synthesize viewController = _viewController;
@synthesize board = _board;
@synthesize toolbar = _toolbar;
@synthesize superview = _superview;
@synthesize player = _player;

@synthesize origin = _origin;
@synthesize coordinate = _coordinate;
@synthesize size = _size;
@synthesize lastTouch = _lastTouch;
@synthesize lastTouchedTile = _lastTouchedTile;
@synthesize tiles = _tiles;
@synthesize image = _image;
@synthesize name = _name;
@synthesize isPlayed = _isPlayed;

- (id)init {
    self = [super init];
    if (self) {
		_origin = CGPointZero;
		_tiles = [[NSMutableArray alloc] init];
		_image = nil;
		_name = nil;
    }
    return self;
}

- (void) setOrigin:(CGPoint)point
{
	CGSize distance = CGSizeMake(point.x - origin.x, point.y - origin.y);
	[self moveTiles:distance];
	origin = point;
}

- (void) setCoordinate:(CGPoint)point {
	CGPoint newOrigin = CGPointMake(point.x * TILE_SIZE, point.y * TILE_SIZE);
	[self setOrigin:newOrigin];
	coordinate = point;
}
 
- (void) moveTiles:(CGSize) distance
{
	NSLog(@"Moving Piece: %f X %f", distance.width, distance.height);
    for (MJTile* t in _tiles) {
		[t moveDistance:distance];
	}
	origin = CGPointMake(origin.x + distance.width, origin.y + distance.height);
}

- (void) snapToPoint
{
    CGSize distance = CGSizeZero;
	int offX = (int)origin.x % TILE_SIZE;
	int offY = (int)origin.y % TILE_SIZE;
	if ((offX / ((CGFloat)TILE_SIZE - 1)) > 0.5f) {
		distance.width += (TILE_SIZE - offX);
	}
	else {
		distance.width -= offX;
	}
	if ((offY / ((CGFloat)TILE_SIZE - 1)) > 0.5f) {
		distance.height += (TILE_SIZE - offY);
	}
	else {
		distance.height -= offY;
	}
	
	[self moveTiles:distance];
	
}

- (void) addAsSubviewToView:(UIView*)view
{
	NSLog(@"Adding Piece to View: %@", NSStringFromClass(view.class));
    for (MJTile* t in _tiles) {
		[view addSubview:t];
		NSLog(@"Adding tile at point: (%f, %f)", t.frame.origin.x, t.frame.origin.y);
	}
	[self setSuperview:view];
}

- (void) removeFromSuperview
{
    for (MJTile* t in _tiles) {
		NSLog(@"Removing Tile From Superview");
		[t removeFromSuperview];
	}
	[self setSuperview:nil];
}

- (void) loadDebugTiles
{
    MJTile* tile = [[MJTile alloc] initWithCoordinate:CGPointMake(0, 0)];
	[tile setPiece:self];
	[tile setDelegate:self];
	[self addTile:tile];
}

- (void) addTile:(MJTile*)tile
{
    if (tile.frame.size.width > size.width) {
		size.width = tile.frame.size.width;
	}
	if (tile.frame.size.height > size.height) {
		size.height = tile.frame.size.height;
	}
	
	[_tiles addObject:tile];
}

- (void) revertToStartingSize
{
    
}

- (void) setScale:(CGFloat)scale
{
    
}

- (UIView*) view {
	UIView* view = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, size.width, size.height)];
	return view;
}

#pragma mark - MJTileDelegate Methods
- (void) touchesBegan:(UITouch*)touch {
	[_viewController addPiece:self];
//	[self moveTiles:<#(CGSize)#>];
	
	//Highlight piece
}
- (void) touchesMoved:(CGSize)distance {
	[self moveTiles:distance];
}
- (void) touchesEnded:(UITouch*)touch {
//	CGPoint point = [touch locationInView:_viewController.view];
	if ([_board pointInside:[touch locationInView:_board] withEvent:nil]) {
		[self setDelegate:_board];
		lastTouch = [touch locationInView:(UIView*)_board.containerView];
	}
	else if ([_toolbar pointInside:[touch locationInView:_toolbar] withEvent:nil]) {
		[self setDelegate:_toolbar];
		lastTouch = [touch locationInView:_toolbar];
	}
	else {
		NSLog(@"Piece dropped in unsupported view");
		abort();
	}
//	lastTouch = point;
	#warning Remove from starting view
	[_delegate addPiece:self];
}
- (void) touchesCanceled: (CGSize)distanceTraveled {
	[self moveTiles:CGSizeMake(distanceTraveled.width * -1, distanceTraveled.height * -1)];
}

@end
