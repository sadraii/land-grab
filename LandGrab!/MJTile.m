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
@synthesize piece = _piece;
@synthesize coordinate = _coordinate;
@synthesize currentPoint = _currentPoint;
@synthesize board = _board;
@synthesize toolbar = _toolbar;
@synthesize viewController = _viewController;
@synthesize isPlayed = _isPlayed;
@synthesize player = _player;

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

- (void) snapToPoint
{
	CGPoint origin = self.frame.origin;
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
	
	
	[self moveDistance:distance];
	[self updateCoordinate];
	
}

#pragma mark - Touches
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* touch = [touches anyObject];
	CGPoint point = [touch locationInView:_viewController.view];
//	NSLog(@"Tile: ((%f, %f), (%f X %f))", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
	[self removeFromSuperview];
	if(_piece){
		[_piece setLastTouchedTile:self];
	}
	_currentPoint = point;
	distanceTraveled = CGSizeMake(0, 0);
	
	
	
	
	[_board setScrollEnabled:NO];
	[self setFrame:CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height)];
	[_viewController.view addSubview:self];//DONT USE THIS
//	[_viewController addPiece:self];
	NSLog(@"Superview: %@", NSStringFromClass(self.superview.class));

}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* touch = [touches anyObject];
	CGPoint point = [touch locationInView:self.superview];
	NSLog(@"Superview: %@", NSStringFromClass(self.superview.class));
	CGSize distance = CGSizeMake(point.x - _currentPoint.x, point.y - _currentPoint.y);
	distanceTraveled.width += distance.width;
	distanceTraveled.height += distance.height;
	
	if (_piece) {
		[_delegate touchesMoved:distanceTraveled];
	}
	else {
		[self moveDistance:distance];
	}
	
	
	_currentPoint = point;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* touch = [touches anyObject];
//	CGPoint point = [touch locationInView:_piece.superview];
//	NSLog(@"Distance Traveled: %f X %f", distanceTraveled.width, distanceTraveled.height);
	
	if (_piece) {
		[_delegate touchesEnded:touch];
		return;
	}
	CGPoint point = CGPointZero;
	
	if ([_board pointInside:[touch locationInView:_board] withEvent:nil]) {
		//[self setDelegate:_board];
		point = [touch locationInView:(UIView*)_board.containerView];
		//add the orgin of the containerview to last touch so it doesnt jump around.
		point.x += _board.frame.origin.x;
		point.y += _board.frame.origin.y;
		[self setFrame:CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height)];
		[_board addPiece:self];
	}
	else if ([_toolbar pointInside:[touch locationInView:_toolbar] withEvent:nil]) {
		//[self setDelegate:_toolbar];
		point = [touch locationInView:_toolbar];
		[self setFrame:CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height)];
		[_toolbar addPiece:self];
	}
	else {
		NSLog(@"Piece dropped in unsupported view");
		//[self touchesCancelled:touches withEvent:event];
		abort();
	}
	[_board setScrollEnabled:YES];
	
	
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[_delegate touchesCanceled:distanceTraveled];
}

@end
