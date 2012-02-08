//
//  MJPiece.m
//  MAKJAM
//
//  Created by Andrew Huss on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJPiece.h"
#import "MJViewController.h"

@implementation MJPiece
@synthesize delegate = _delegate;
@synthesize parentViewController = _parentViewController;
@synthesize board = _board;
@synthesize toolbar = _toolbar;

-(id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame]) == nil) {
		return self;
    }
	[self setUserInteractionEnabled:YES];
    startingCenter = CGPointZero;
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	NSLog(@"%@: %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
	startingCenter = self.center;
	[_toolbar setScrollEnabled:NO];
	
	UITouch* touch = [touches anyObject];
	CGPoint point = [touch locationInView:_parentViewController.view];
	currentPosition = point;
	
	if ([_board isEqual:self.superview]) {
		NSLog(@"Touch in Board");
		[self setDelegate:_board];
		startingView = _board;
	}
	else if ([_toolbar isEqual:self.superview]) {
		NSLog(@"Touch in Toolbar");
		[self setDelegate:_toolbar];
		startingView = _toolbar;
	}
	else {
		NSLog(@"ERROR: unknown superview: %@", NSStringFromClass(self.superview.class));
//		if ([self.superview conformsToProtocol:@protocol(MJPieceDelegate)]) {
////			[self setDelegate:self.superview];
//		}
		abort();
	}
	
	CGPoint tmpTouch = [touch locationInView:self.superview];
	distanceFromCenter.x = self.center.x - tmpTouch.x;
	distanceFromCenter.y = self.center.y - tmpTouch.y;
	
	CGFloat newX = point.x + distanceFromCenter.x;
	CGFloat newY = point.y + distanceFromCenter.y;
//	CGFloat newX = self.center.x + self.superview.frame.origin.x;
//	CGFloat newY = self.center.y + self.superview.frame.origin.y;
	[self setCenter:CGPointMake(newX, newY)];
	
	[self setDelegate:_parentViewController];
	[_parentViewController addPiece:self];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//	NSLog(@"%@: %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
	UITouch* touch = [touches anyObject];
	CGPoint point = [touch locationInView:_parentViewController.view];
	
	[self setCenter:[self centerFromPoint:point]];
	currentPosition = point;
}

/*
 Returns a new center point for the piece. Finger stays in same position during draggin. Adds the difference of the last recorded point and the new point to both the x and y of the center
 */
- (CGPoint) centerFromPoint:(CGPoint)point {
//	NSLog(@"%@: %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
	return CGPointMake(self.center.x + (point.x - currentPosition.x), 
					   self.center.y + (point.y - currentPosition.y));
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"%@: %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
	[_toolbar setScrollEnabled:YES];
	if ([startingView conformsToProtocol:@protocol(MJPieceDelegate)]) {
		[self setDelegate:(id <MJPieceDelegate>)startingView];
		[self setCenter:startingCenter];
		NSLog(@"Adding back to: %@ at (%f, %f)", NSStringFromClass(startingView.class), self.center.x, self.center.y);
		[_delegate removePiece:self];
		[_delegate addPiece:self];
	}
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"%@: %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
	UITouch* touch = [touches anyObject];
	
	[(id <MJPieceDelegate>)startingView removePiece:self];
	[_delegate removePiece:self];
	[_toolbar setScrollEnabled:YES];
	
	if ([_toolbar pointInside:[touch locationInView:_toolbar] withEvent:nil]) {
//	if ([_toolbar pointInside:self.center withEvent:nil]) {
		NSLog(@"Add to toolbar");
		[self setDelegate:_toolbar];
	}
	else if ([_board pointInside:[touch locationInView:_board] withEvent:nil]) {
//	else if ([_board pointInside:self.center withEvent:nil]) {
		NSLog(@"Add to board");
		[self setDelegate:_board];
	}
	else {
		NSLog(@"Could not find a view to add self to: %@", [self.superview class]);
		[self touchesCancelled:nil withEvent:nil];
		return;
	}
	if (![_delegate addPiece:self]) {
		//Should animate
		[self touchesCancelled:nil withEvent:nil];
	}
}

@end

