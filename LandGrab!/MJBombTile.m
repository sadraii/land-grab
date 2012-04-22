//
//  MJBombTile.m
//  LandGrab!
//
//  Created by student on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJBombTile.h"

@implementation MJBombTile

@synthesize delegate = _delegate;

@synthesize viewController = _viewController;
@synthesize board = _board;
@synthesize toolbar = _toolbar;

@synthesize player = _player;
@synthesize currentPoint = _currentPoint;

#pragma mark - Touches

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    
	UITouch* touch = [touches anyObject];
	CGPoint point = [touch locationInView:_viewController.view];
	startingView = self.superview;
	startingOrigin = self.frame.origin;
	_currentPoint = point;
	distanceTraveled = CGSizeMake(0, 0);
	[_board setScrollEnabled:NO];
	distanceFromOrigin = [self distanceFromOrigin:[touch locationInView:self]];
	point.x -= distanceFromOrigin.width;
	point.y -= distanceFromOrigin.height;
	[self setFrame:CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height)];
	[_toolbar fadeBombCounter];
	
    [_viewController addTile:self];
	if (_board.zoomScale != _board.maximumZoomScale) {
		if (_player.lastPlayedTile) {
            
		}
		else {
		}
	}
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* touch = [touches anyObject];
	CGPoint point = [touch locationInView:self.superview];
	CGSize distance = CGSizeMake(point.x - _currentPoint.x, point.y - _currentPoint.y);
	
    
    
	[self moveDistance:distance];
	
	distanceTraveled.width += distance.width;
	distanceTraveled.height += distance.height;
	_currentPoint = point;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* touch = [touches anyObject];
	CGPoint point = CGPointZero;
	if ([_board pointInside:[touch locationInView:_board] withEvent:nil]) {
		if (_board.zoomScale != 1) {
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Must zoom all the way in to place a bomb" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
			[alert show];
			
            [self touchesCancelled:touches withEvent:event];
            
		}
		else {
			point = [touch locationInView:(UIView*)_board.containerView];
			point.x -= distanceFromOrigin.width;
			point.y -= distanceFromOrigin.height;
			[self setFrame:CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height)];
			[self snapToPoint];
            
            
			[_board addBombTile:self];
		}
        
	}
	else if ([_toolbar pointInside:[touch locationInView:_toolbar] withEvent:nil]) {
		//
		// Since we do not need the ability to place tiles back on the toolbar as of yet, we can just call touches cancelled right here instead.
		//
		/*
         point = [touch locationInView:_toolbar];
         [self setFrame:CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height)];
         [_toolbar addTile:self];
		 */
		[self touchesCancelled:touches withEvent:event];
        
	}
	else {
		NSLog(@"Piece dropped in unsupported view");
        
		[self touchesCancelled:touches withEvent:event];
	}
	[_board setScrollEnabled:YES];
    
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[self setFrame:CGRectMake(startingOrigin.x, startingOrigin.y, self.frame.size.width, self.frame.size.height)];
	if ([startingView isEqual:_toolbar]) {
        
        [_toolbar addBombTile:self];
        [_toolbar animateBombCounter];
	}
	else {
        [_toolbar animateBombCounter];
		abort();
	}
    
    
}

@end
