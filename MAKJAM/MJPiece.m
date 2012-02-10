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
@synthesize scale = _scale;
@synthesize startingSize = _startingSize;

-(id) initWithImage:(UIImage *)image {
    if ((self = [super initWithImage:image]) == nil) {
		return self;
    }
    [self setUserInteractionEnabled:YES];
	[self setContentMode:UIViewContentModeScaleAspectFill];
    startingCenter = CGPointZero;
	_scale = 1;
	_startingSize = self.image.size;
    return self;
}

-(id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame]) == nil) {
		return self;
    }
	[self setUserInteractionEnabled:YES];
    startingCenter = CGPointZero;
	_scale = 1;
	_startingSize = self.frame.size;
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	startingCenter = self.center;
	[_toolbar setScrollEnabled:NO];
	[_board setScrollEnabled:NO];
	
	UITouch* touch = [touches anyObject];
	CGPoint point = [touch locationInView:_parentViewController.view];
	currentPosition = point;
	
	CGPoint tmpTouch = [touch locationInView:self.superview];
	
	if ([_board.containerView isEqual:self.superview]) {
		[self setDelegate:_board];
		startingView = _board;
		
		distanceFromCenter.x = (self.center.x - tmpTouch.x) * _board.zoomScale;
		distanceFromCenter.y = (self.center.y - tmpTouch.y) * _board.zoomScale;
		CGFloat newX = point.x + distanceFromCenter.x;
		CGFloat newY = point.y + distanceFromCenter.y;
		[self setCenter:CGPointMake(newX, newY)];
	}
	else if ([_toolbar isEqual:self.superview]) {
		[self setDelegate:_toolbar];
		startingView = _toolbar;
		
		distanceFromCenter.x = self.center.x - tmpTouch.x;
		distanceFromCenter.y = self.center.y - tmpTouch.y;
		
		CGFloat newX = point.x + distanceFromCenter.x;
		CGFloat newY = point.y + distanceFromCenter.y;
		
		[self setCenter:CGPointMake(newX, newY)];
	}
	else {
		NSLog(@"ERROR: unknown superview: %@", NSStringFromClass(self.superview.class));
		abort();
	}
	[self setDelegate:_parentViewController];
	[_parentViewController addPiece:self];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* touch = [touches anyObject];
	CGPoint point = [touch locationInView:_parentViewController.view];
	
	[self setCenter:[self centerFromPoint:point]];
	currentPosition = point;
}

/*
 Returns a new center point for the piece. Finger stays in same position during draggin. Adds the difference of the last recorded point and the new point to both the x and y of the center
 */
- (CGPoint) centerFromPoint:(CGPoint)point {
	return CGPointMake(self.center.x + (point.x - currentPosition.x), 
					   self.center.y + (point.y - currentPosition.y));
}

- (void) revertToStartingSize {
	if (!CGSizeEqualToSize(self.frame.size, self.startingSize)) {
		CGPoint originalCenter = self.center;
		[self setFrame:CGRectMake(0, 0, self.startingSize.width, self.startingSize.height)];
		[self setCenter:originalCenter];
	}
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"%@: %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
	[_toolbar setScrollEnabled:YES];
	[_board setScrollEnabled:YES];
	if ([startingView conformsToProtocol:@protocol(MJPieceDelegate)]) {
		[self setDelegate:(id <MJPieceDelegate>)startingView];
		[self setCenter:startingCenter];
		NSLog(@"Adding back to: %@ at (%f, %f)", NSStringFromClass(startingView.class), self.frame.origin.x, self.frame.origin.y);
		[_delegate removePiece:self];
		[_delegate addPiece:self];
	}
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//	NSLog(@"%@: %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
	UITouch* touch = [touches anyObject];
	
	[(id <MJPieceDelegate>)startingView removePiece:self];
	[_delegate removePiece:self];
	[_toolbar setScrollEnabled:YES];
	[_board setScrollEnabled:YES];
	
	if ([_toolbar pointInside:[touch locationInView:_toolbar] withEvent:nil]) {
		/*
		 Chaing center to the users touch point so that when added to the toolbar it drops at users touch instead of piece center
		 allowing for a more natural dropping experience.
		 */
		[self setCenter:[touch locationInView:_toolbar]];
		[self setDelegate:_toolbar];
	}
	else if ([_board.containerView pointInside:[touch locationInView:_board.containerView] withEvent:nil]) {
		[self setCenter:[self centerFromPoint:[touch locationInView:_board.containerView]]];
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

