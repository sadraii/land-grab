//
//  MJTile.m
//  LandGrab!
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJTile.h"
#import "MJPiece.h"
#import "MJPlayer.h"
#import "MJToolbar.h"
#import "MJViewController.h"
#import "MJBoard.h"

@implementation MJTile

@synthesize delegate = _delegate;

@synthesize viewController = _viewController;
@synthesize board = _board;
@synthesize toolbar = _toolbar;

@synthesize piece = _piece;
@synthesize player = _player;

@synthesize coordinate = _coordinate;
@synthesize currentPoint = _currentPoint;
@synthesize isPlayed = _isPlayed;

#pragma mark - Class Methods
-(id) initWithCoordinate:(CGPoint)aCoordinate; {
    if ((self = [super init]) == nil) {
		return self;
    }
    _coordinate = aCoordinate;
	[self setFrame:CGRectMake(_coordinate.x * TILE_SIZE, _coordinate.y * TILE_SIZE, TILE_SIZE, TILE_SIZE)];
	[self setBackgroundColor:[UIColor whiteColor]];
    return self;
}

- (void) moveDistance:(CGSize) distance {
	[self setFrame:CGRectMake(self.frame.origin.x + distance.width, self.frame.origin.y + distance.height, self.frame.size.width, self.frame.size.height)];
}

- (void) updateCoordinate {
	CGPoint origin = self.frame.origin;
	_coordinate = CGPointMake(origin.x / TILE_SIZE, origin.y / TILE_SIZE);
	NSLog(@"Tile Coordinate: (%i, %i)", (int)_coordinate.x, (int)_coordinate.y);
}

- (void) snapToPoint
{
	NSLog(@"Origin: (%f, %f)", self.frame.origin.x, self.frame.origin.y);
	CGPoint origin = self.frame.origin;
    CGSize distance = CGSizeZero;
	int offX = (int)origin.x % TILE_SIZE;
	int offY = (int)origin.y % TILE_SIZE;
	if ((offX / ((CGFloat)TILE_SIZE - 1)) >= 0.5f) {
		distance.width += (TILE_SIZE - offX);
	}
	else {
		distance.width -= offX;
	}
	if ((offY / ((CGFloat)TILE_SIZE - 1)) >= 0.5f) {
		distance.height += (TILE_SIZE - offY);
	}
	else {
		distance.height -= offY;
	}
	
	
	[self moveDistance:distance];
	[self updateCoordinate];
}

- (CGSize) distanceFromOrigin:(CGPoint)point {
	CGSize distance = CGSizeZero;
	CGPoint origin = self.frame.origin;
	distance.width = point.x;
	distance.height = point.y;
	return distance;
}

#pragma mark - Touches
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* touch = [touches anyObject];
	CGPoint point = [touch locationInView:_viewController.view];
	startingView = self.superview;
	startingOrigin = self.frame.origin;
	_currentPoint = point;
	distanceTraveled = CGSizeMake(0, 0);
	[_board setScrollEnabled:NO];
	if(_piece){
		[_piece setLastTouchedTile:self];
		[_delegate touchesBegan:touch];
	}
	else {
		distanceFromOrigin = [self distanceFromOrigin:[touch locationInView:self]];
		point.x -= distanceFromOrigin.width;
		point.y -= distanceFromOrigin.height;
		[self setFrame:CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height)];
		[_viewController addPiece:self];
	}
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* touch = [touches anyObject];
	CGPoint point = [touch locationInView:self.superview];
	CGSize distance = CGSizeMake(point.x - _currentPoint.x, point.y - _currentPoint.y);
	
	if (_piece) {
		[_delegate touchesMoved:distance];
	}
	else {
		[self moveDistance:distance];
	}
	
	distanceTraveled.width += distance.width;
	distanceTraveled.height += distance.height;
	_currentPoint = point;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* touch = [touches anyObject];
	
	if (_piece) {
		[_delegate touchesEnded:touch];
		return;
	}
	else {
		CGPoint point = CGPointZero;
		if ([_board pointInside:[touch locationInView:_board] withEvent:nil]) {
			point = [touch locationInView:(UIView*)_board.containerView];
			point.x -= distanceFromOrigin.width;
			point.y -= distanceFromOrigin.height;
			[self setFrame:CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height)];
			
			[_board addPiece:self];
		}
		else if ([_toolbar pointInside:[touch locationInView:_toolbar] withEvent:nil]) {
			point = [touch locationInView:_toolbar];
			[self setFrame:CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height)];
			[_toolbar addPiece:self];
		}
		else {
			NSLog(@"Piece dropped in unsupported view");
			[self touchesCancelled:touches withEvent:event];
		}
		[_board setScrollEnabled:YES];
	}
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	if (_piece) {
		[_delegate touchesCanceled:distanceTraveled];
	}
	else {
		[self setFrame:CGRectMake(startingOrigin.x, startingOrigin.y, self.frame.size.width, self.frame.size.height)];
		if ([startingView isEqual:_toolbar]) {
			[_toolbar addPiece:self];
		}
		else {
			abort();
		}
	}
}

@end
