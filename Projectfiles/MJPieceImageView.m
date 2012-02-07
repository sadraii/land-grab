//
//  MJPieceImageView.m
//  MAKJAM
//
//  Created by Andrew Huss on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJPieceImageView.h"

@implementation MJPieceImageView
@synthesize delegate = _delegate;
@synthesize toolbar = _toolbar;

-(id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame]) == nil) {
		return self;
    }
	[self setUserInteractionEnabled:YES];
    startingPosition = CGPointZero;
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	CCLOG(@"%@: %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
	NSLog(@"Running Scene: %@", NSStringFromClass([[CCDirector sharedDirector] runningScene].class));
	CCScene* runningScene = [[CCDirector sharedDirector] runningScene];
	if (![runningScene conformsToProtocol:@protocol(MJPieceImageViewDelegate)]) {
		return;
	}
	[self setDelegate:(id <MJPieceImageViewDelegate>)runningScene];
	UITouch* touch = [touches anyObject];
	UIView* backgroundView = self.superview.superview; 
	CGPoint point = [touch locationInView:backgroundView];
	
	currentPosition = point;
	startingPosition = self.center;
	
	[_toolbar setScrollEnabled:NO];
	
	/*
	 If we want to add multitouch capabilities, then we need to move this if statement to touches did move. When it is in touches began, and you try and move two pieces at the same time, the first one acts normal but since you did a removePiece: it shifts the rest to the left.
	 */
	if ([[self superview] isEqual:_toolbar]) {
		NSLog(@"In toolbar: add board height");
		[_toolbar removePiece:self];
		[self setCenter:CGPointMake(self.center.x, self.center.y + (backgroundView.frame.size.height- _toolbar.frame.size.height))];
	}
	else {
		NSLog(@"Oops, unknown superview: %@", NSStringFromClass(self.superview.class));
		[self removeFromSuperview];
	}
	[backgroundView addSubview:self];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	CCLOG(@"%@: %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
	UIView* backgroundView = self.superview.superview;
	
	UITouch* touch = [touches anyObject];
	CGPoint point = [touch locationInView:backgroundView];
	[self setCenter:[self centerFromPoint:point]];
	currentPosition = point;
}

/*
 Returns a new center point for the piece. Finger stays in same position during draggin. Adds the difference of the last recorded point and the new point to both the x and y of the center
 */
- (CGPoint) centerFromPoint:(CGPoint)point {
	CCLOG(@"%@: %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
	return CGPointMake(self.center.x + (point.x - currentPosition.x), 
					   self.center.y + (point.y - currentPosition.y));
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	CCLOG(@"%@: %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
	[_toolbar setScrollEnabled:YES];
	//	[_board setUserInteractionEnabled:YES];
	//	[startingView addPiece:self];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	CCLOG(@"%@: %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
	UITouch* touch = [touches anyObject];
	UIView* backgroundView = self.superview.superview;
	
	[_toolbar setScrollEnabled:YES];
	
	if ([_toolbar pointInside:[touch locationInView:_toolbar] withEvent:nil]) {
		[_toolbar addPiece:self];
		NSLog(@"Added to toolbar");
	}
	else if ([backgroundView pointInside:[touch locationInView:backgroundView] withEvent:nil]) {
		if (![_delegate handleDroppedPiece:self]) {
			//Should animate
			[self setCenter:startingPosition];
			[_toolbar addPiece:self];
		}
		NSLog(@"Added to board");
	}
	else {
		NSLog(@"Could not find a view to add self to: %@", [self.superview class]);
		[self removeFromSuperview];
	}
}

@end
