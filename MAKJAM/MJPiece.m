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
@synthesize transparentTiles = _transparentTiles;
@synthesize scale = _scale;
@synthesize startingSize = _startingSize;

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

- (void) rotatePiece {
	NSLog(@"Starting Origin: (%f, %f)", self.frame.origin.x, self.frame.origin.y);
	CGPoint originalOrigin = self.frame.origin;
	self.layer.anchorPoint = CGPointMake(.5,.5);
	currentRotation >= 3 ? currentRotation = 0 : currentRotation++;
	NSLog(@"Current Rotation: %i", currentRotation);
	self.transform = CGAffineTransformRotate(self.transform, degreesToRadians(90));
	
	[self setFrame:CGRectMake(originalOrigin.x, originalOrigin.y, self.frame.size.width, self.frame.size.height)];
	
	NSLog(@"Self Bounds: (%f X %f)", self.bounds.size.width, self.bounds.size.height);
	NSLog(@" Self Frame: (%f X %f)", self.frame.size.width, self.frame.size.height);
	NSLog(@"Ending Origin: (%f, %f)", self.frame.origin.x, self.frame.origin.y);
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
	//NEED TO FIGURE OUT HOW TO DO THIS!!
	/*
	 need to record the starting width and starting size
	 need to store the current rotation (1 , 2 ,3, 4) or (0, 1, 2, 3)
	 if rotation % 2 is 0 then piece is upside down
		set size to starting size (width X height)
	 if rotation % 2 is 1 then piece is sideways
		set size to flipped starting size (height X width)
	 */
	currentRotation % 2 ? NSLog(@"Rotation is 1") : NSLog(@"Rotation is 0");
	currentRotation % 2 ? [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, _startingSize.height, _startingSize.width)] : [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, _startingSize.width, _startingSize.height)]; 
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
	[self setRotateButtonHidden:YES];
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
	else {
		[self setRotateButtonHidden:YES];
	}
}

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

