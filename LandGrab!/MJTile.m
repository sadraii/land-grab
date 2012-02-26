//
//  MJTile.m
//  LandGrab!
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJTile.h"
#import "MJPiece.h"

@implementation MJTile

@synthesize delegate = _delegate;
@synthesize piece = _piece;
@synthesize coordinate = _coordinate;
@synthesize currentPoint = _currentPoint;

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

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//		_coordinate = CGPointMake(frame.origin.x / TILE_SIZE, frame.origin.y / TILE_SIZE);
//        [self setBackgroundColor:[UIColor whiteColor]];
//    }
//    return self;
//}

- (CGPoint) centerFromPoint:(CGPoint)point {
	return CGPointMake(self.center.x + (point.x - currentPoint.x), 
					   self.center.y + (point.y - currentPoint.y));
}

- (void) moveDistance:(CGSize) distance {
	[self setFrame:CGRectMake(self.frame.origin.x + distance.width, self.frame.origin.y + distance.height, self.frame.size.width, self.frame.size.height)];
	[self updateCoordinate];
}

- (void) updateCoordinate {
	CGPoint origin = self.frame.origin;
	coordinate = CGPointMake(origin.x / TILE_SIZE, origin.y / TILE_SIZE);
}

#pragma mark - Touches
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* touch = [touches anyObject];
//	NSLog(@"Tile: ((%f, %f), (%f X %f))", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
	[_piece setLastTouchedTile:self];
	_currentPoint = [touch locationInView:_piece.superview];
	NSLog(@"Tile Current Touch: (%f, %f)", _currentPoint.x, _currentPoint.y);
	distanceTraveled = CGSizeMake(0, 0);
	[_delegate touchesBegan:touch];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* touch = [touches anyObject];
	CGPoint point = [touch locationInView:_piece.superview];
	CGSize distance = CGSizeMake(point.x - _currentPoint.x, point.y - _currentPoint.y);
	distanceTraveled.width += distance.width;
	distanceTraveled.height += distance.height;
	[_delegate touchesMoved:distance];
	_currentPoint = point;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* touch = [touches anyObject];
//	CGPoint point = [touch locationInView:_piece.superview];
//	NSLog(@"Distance Traveled: %f X %f", distanceTraveled.width, distanceTraveled.height);
	[_delegate touchesEnded:touch];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[_delegate touchesCanceled:distanceTraveled];
}

@end
