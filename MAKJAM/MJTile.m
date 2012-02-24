//
//  MJTile.m
//  MAKJAM
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
@synthesize frame = _frame;

const NSUInteger TILE_SIZE = 64;

-(id) initWithCoordinate:(CGPoint)aCoordinate {
    if ((self = [super initWithFrame:CGRectMake(aCoordinate.x * TILE_SIZE, aCoordinate.y * TILE_SIZE, TILE_SIZE, TILE_SIZE)]) == nil) {
		return self;
    }
    _coordinate = coordinate;
	_frame = CGRectMake(TILE_SIZE * _coordinate.x, TILE_SIZE * _coordinate.y, TILE_SIZE, TILE_SIZE);
	[self setBackgroundColor:[UIColor blackColor]];
    return self;
}

#pragma mark - Class Metods
+ (NSUInteger) tileSize {
	return TILE_SIZE;
}
- (CGPoint) centerFromPoint:(CGPoint)point {
	return CGPointMake(self.center.x + (point.x - currentPoint.x), 
					   self.center.y + (point.y - currentPoint.y));
}


#pragma mark - Touches
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* touch = [touches anyObject];
	currentPoint = [touch locationInView:self];
	
	distanceTraveled = CGSizeMake(0, 0);
	
	[_delegate touchesBegan:currentPoint];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	CGSize distance = CGSizeMake(point.x - currentPoint.x, point.y - currentPoint.y);
	distanceTraveled.width += distance.width;
	distanceTraveled.height += distance.height;
	[_delegate touchesMoved:distance];
	currentPoint = point;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	[_delegate touchesEnded:point];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[_delegate touchesCanceled:distanceTraveled];
}
#pragma mark -

@end
