//
//  MJPiece.m
//  MAKJAM
//
//  Created by Andrew Huss on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MJPiece.h"
#import "MJViewController.h"

#define degreesToRadians(x) (M_PI * x / 180.0)

@implementation MJPiece
@synthesize delegate = _delegate;
@synthesize parentViewController = _parentViewController;
@synthesize board = _board;
@synthesize toolbar = _toolbar;
@synthesize played = _played;
@synthesize transparentTiles = _transparentTiles;
@synthesize scale = _scale;
@synthesize startingSize = _startingSize;
@synthesize area = _area;

/*
 The initializer that is used for initinalizing all pieces.
 IVARS should generally be set to zero
 StartingSize is set to the images size
 */
-(id) initWithImage:(UIImage *)image {
    if ((self = [super initWithImage:image]) == nil) {
		return self;
    }
    [self setUserInteractionEnabled:YES];
	[self setContentMode:UIViewContentModeScaleAspectFit];
	[self clipsToBounds];
//	[self setBackgroundColor:[UIColor redColor]];
	
    startingCenter = CGPointZero;
	currentRotation = 0;
	_scale = 1;
	_startingSize = self.image.size;
    return self;
}

/*
 Override the TransparentTiles property
 Since the points stored in the plist are not formatted correctly, this function will add {} to the outside of each point.
 Sets the area to the image area minus the number of transparent tiles
 */
- (void) setTransparentTiles:(NSArray *)transparentTiles {
	_transparentTiles = nil;
	NSMutableArray* array = [[NSMutableArray alloc] init];
	for (NSString* p in transparentTiles) {
		[array addObject:[NSString stringWithFormat:@"{%@}",p]];
	}
	_transparentTiles = [NSArray arrayWithArray:array];
	_area = ((self.frame.size.width * self.frame.size.height) / pow(2, _board.tileSize)) - [_transparentTiles count];
}

/*
 Rotates a piece clockwise
 The orgin (top left) will stay the same as before the rotation.
 */
- (void) rotatePiece {
	CGPoint originalOrigin = self.frame.origin;
	self.layer.anchorPoint = CGPointMake(.5,.5);
	currentRotation >= 3 ? currentRotation = 0 : currentRotation++;
	self.transform = CGAffineTransformRotate(self.transform, degreesToRadians(90));
	[self setFrame:CGRectMake(originalOrigin.x, originalOrigin.y, self.frame.size.width, self.frame.size.height)];
}

/*
 Sets the starting center
 Sets the current location of the touch (inside the piece)
 Sets the starting view to the pieces superview (incase of touches canceled, and so the piece can be removed from the starting view at touches did end)
 Sets the delegate to the View Controller
 Adds the piece to the delegate
 Shows the rotate button
 */
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
		//need to animate this!!!!!!!!
		
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
	[self setRotateButtonHidden:NO];
}

/*
 Moves the pieces center the same ammount the users touch has traveled
 It keeps the center the same relative distance from the initial touch.
 */
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* touch = [touches anyObject];
	CGPoint point = [touch locationInView:_parentViewController.view];
	
	[self setCenter:[self centerFromPoint:point]];
	currentPosition = point;
}

/*
 Returns a new center point for the piece. Finger stays in same position during dragging. Adds the difference of the last recorded point and the new point to both the x and y of the center
 */
- (CGPoint) centerFromPoint:(CGPoint)point {
	return CGPointMake(self.center.x + (point.x - currentPosition.x), 
					   self.center.y + (point.y - currentPosition.y));
}

/*
 Sets the height and the width of the frame to the relative starting size of the image.
 Keeps the origin the same as before the revert to original size.
 */
- (void) revertToStartingSize {
	currentRotation % 2 ? NSLog(@"Rotation is odd") : NSLog(@"Rotation is even");
	currentRotation % 2 ? [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, _startingSize.height, _startingSize.width)] : [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, _startingSize.width, _startingSize.height)]; 
}

/*
 Sets the delegate to the starting view
 Then removes and adds the piece back into the delegate
 Sets the center to the starting center
 Sets the rotate button to hidden
 */
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"%@: %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
	NSLog(@"Adding back to: %@ at (%f, %f)", NSStringFromClass(startingView.class), self.frame.origin.x, self.frame.origin.y);
	
	[_toolbar setScrollEnabled:YES];
	[_board setScrollEnabled:YES];
	[self setDelegate:(id <MJPieceDelegate>)startingView];
	[self setCenter:startingCenter];
	[_delegate removePiece:self];
	[_delegate addPiece:self];
	[self setRotateButtonHidden:YES];
}


/*
 Removes the piece from the starting view
 Removes the piece from the current delegate(ViewController)
 Enables scroll on the toolbar and board
 Finds which view the current user touch is in.
 If the point is in the toolbar
	it will insert the piece at the users touch
 If the point is in the board
	it will add the piece at the current center/origin
 If the point is in anything else we call touches cancelled. (should never happend)
 If unable to add piece to final view we will also call touches cancelled.
 Else we hide the rotate button
 */
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
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
	else {
		[self setRotateButtonHidden:YES];
	}
}

/*
 Shows or hides the rotate button
 Alters the frame size of the toolbar so that the rotate buton does not lay on top of it
 */
- (void) setRotateButtonHidden:(BOOL)hidden {
	[_parentViewController.rotateButton setHidden:hidden];
	if (hidden) {
		[_parentViewController.rotateButton removeTarget:self action:@selector(rotatePiece) forControlEvents:UIControlEventTouchUpInside];
		CGRect tFrame = _toolbar.frame;
		CGRect rFrame = _parentViewController.rotateButton.frame;
		[_toolbar setFrame:CGRectMake(tFrame.origin.x - rFrame.size.width - (2 * _toolbar.offset), tFrame.origin.y, tFrame.size.width + rFrame.size.width/* + (2 * offset)*/, tFrame.size.height)];
	}
	else {
		[_parentViewController.rotateButton addTarget:self action:@selector(rotatePiece) forControlEvents:UIControlEventTouchUpInside];
		CGRect tFrame = _toolbar.frame;
		CGRect rFrame = _parentViewController.rotateButton.frame;
		[_toolbar setFrame:CGRectMake(tFrame.origin.x + rFrame.size.width + (2 * _toolbar.offset), tFrame.origin.y, tFrame.size.width - rFrame.size.width/* - (2 * offset)*/, tFrame.size.height)];
	}
}

@end

