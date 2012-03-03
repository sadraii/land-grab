//
//  MJTile.m
//  LandGrab!
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJTile.h"
#import "MJPlayer.h"
#import "MJToolbar.h"
#import "MJViewController.h"
#import "MJBoard.h"

@implementation MJTile

@synthesize delegate = _delegate;

@synthesize viewController = _viewController;
@synthesize board = _board;
@synthesize toolbar = _toolbar;

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
	[self setFrame:CGRectMake(_coordinate.x * [MJBoard tileSize], _coordinate.y * [MJBoard tileSize], [MJBoard tileSize], [MJBoard tileSize])];
	[self setBackgroundColor:[UIColor whiteColor]];
	[self setAlpha:0.8];
    return self;
}

- (void) moveDistance:(CGSize) distance {
	[self setFrame:CGRectMake(self.frame.origin.x + distance.width, self.frame.origin.y + distance.height, self.frame.size.width, self.frame.size.height)];
}

- (void) updateCoordinate {
	CGPoint origin = self.frame.origin;
	_coordinate = CGPointMake(origin.x / [MJBoard tileSize], origin.y / [MJBoard tileSize]);
}

- (void) snapToPoint
{
	CGPoint origin = self.frame.origin;
	origin.x = roundf(origin.x);
	origin.y = roundf(origin.y);
    CGSize distance = CGSizeZero;
	int offX = (int)origin.x % [MJBoard tileSize];
	int offY = (int)origin.y % [MJBoard tileSize];
	if ((offX / ((CGFloat)[MJBoard tileSize] - 1)) >= 0.5f) {
		distance.width += ([MJBoard tileSize] - offX);
	}
	else {
		distance.width -= offX;
	}
	if ((offY / ((CGFloat)[MJBoard tileSize] - 1)) >= 0.5f) {
		distance.height += ([MJBoard tileSize] - offY);
	}
	else {
		distance.height -= offY;
	}
	
	
	[self moveDistance:distance];
	[self updateCoordinate];
}

- (CGSize) distanceFromOrigin:(CGPoint)point {
	CGSize distance = CGSizeZero;
	distance.width = point.x;
	distance.height = point.y;
	return distance;
}

- (void) setCoordinate:(CGPoint)coordinate {
	[self setFrame:CGRectMake(coordinate.x * [MJBoard tileSize], coordinate.y * [MJBoard tileSize], self.frame.size.width, self.frame.size.height)];
	_coordinate = coordinate;
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
	
	distanceFromOrigin = [self distanceFromOrigin:[touch locationInView:self]];
	point.x -= distanceFromOrigin.width;
	point.y -= distanceFromOrigin.height;
	[self setFrame:CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height)];
	[_viewController addTile:self];
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
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Must zoom all the way in to place a piece" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
			[alert show];
			[self touchesCancelled:touches withEvent:event];
		}
		else {
			point = [touch locationInView:(UIView*)_board.containerView];
			point.x -= distanceFromOrigin.width;
			point.y -= distanceFromOrigin.height;
			[self setFrame:CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height)];
			[self snapToPoint];
			[_board addTile:self];
		}
	}
	else if ([_toolbar pointInside:[touch locationInView:_toolbar] withEvent:nil]) {
		point = [touch locationInView:_toolbar];
		[self setFrame:CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height)];
		[_toolbar addTile:self];
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
		[_toolbar addTile:self];
	}
	else {
		abort();
	}
}
/*
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //Define Colors
    CGColorRef lighterRedColor = [UIColor colorWithRed:1.0 green:0.0 
                                           blue:0.0 alpha:1.0].CGColor;
    CGColorRef redColor = [UIColor colorWithRed:0.6 green:0.0 
                                           blue:0.0 alpha:1.0].CGColor;
    CGColorRef darkerRedColor = [UIColor colorWithRed:0.4 green:0.0 
                                           blue:0.0 alpha:1.0].CGColor;
    
    CGColorRef lighterBlueColor = [UIColor colorWithRed:0.0 green:0.0 
                                                   blue:1.0 alpha:1.0].CGColor;
    CGColorRef blueColor = [UIColor colorWithRed:0.0 green:0.0 
                                           blue:0.6 alpha:1.0].CGColor;
    CGColorRef darkerBlueColor = [UIColor colorWithRed:0.0 green:0.0 
                                                 blue:0.4 alpha:1.0].CGColor;
    
    
    CGColorRef lighterGreenColor = [UIColor colorWithRed:0.0 green:1.0 
                                            blue:0.0 alpha:1.0].CGColor;
    CGColorRef greenColor = [UIColor colorWithRed:0.0 green:0.6 
                                                   blue:0.0 alpha:1.0].CGColor;
    
    CGColorRef lighterTealColor = [UIColor colorWithRed:0.0 green:1.0 
                                            blue:1.0 alpha:1.0].CGColor;
    CGColorRef tealColor = [UIColor colorWithRed:0.0 green:0.5 
                                                   blue:0.5 alpha:1.0].CGColor;
    
    CGColorRef lighterYellowColor = [UIColor colorWithRed:1.0 green:1.0 
                                                    blue:0.0 alpha:1.0].CGColor;
    CGColorRef yellowColor = [UIColor colorWithRed:0.6 green:0.6 
                                             blue:0.0 alpha:1.0].CGColor;
    
    CGFloat outerMargin = 3.0f;
    CGRect outerRect = CGRectInset(self.bounds, outerMargin, outerMargin);

    
    if (self.player.handle == @"Andrew") {
        
        CGMutablePathRef outerPath = createRoundedRectForRect(outerRect, 10.0);
        CGContextSetFillColorWithColor(ctx, lighterBlueColor); // outline
        CGContextFillRect(ctx, self.bounds);
        CGContextSaveGState(ctx);
        CGContextSetFillColorWithColor(ctx, blueColor); // fill
        CGContextAddPath(ctx, outerPath);
        CGContextFillPath(ctx);
        drawLinearGradient(ctx, outerRect, lighterBlueColor, darkerBlueColor);
        CGContextRestoreGState(ctx);
    }
    
    if (self.player.handle == @"Jason") {
        
        CGMutablePathRef outerPath = createRoundedRectForRect(outerRect, 10.0);
        CGContextSetFillColorWithColor(ctx, lighterRedColor); // outline
        CGContextFillRect(ctx, self.bounds);
        CGContextSaveGState(ctx);
        CGContextSetFillColorWithColor(ctx, redColor); // fill
        CGContextAddPath(ctx, outerPath);
        CGContextFillPath(ctx);
        drawLinearGradient(ctx, outerRect, lighterRedColor, darkerRedColor);
        CGContextRestoreGState(ctx);
    }
    
    if (self.player.handle == @"Max") {
        
        CGMutablePathRef outerPath = createRoundedRectForRect(outerRect, 10.0);
        CGContextSetFillColorWithColor(ctx, lighterGreenColor); // outline
        CGContextFillRect(ctx, self.bounds);
        CGContextSaveGState(ctx);
        CGContextSetFillColorWithColor(ctx, greenColor); // fill
        CGContextAddPath(ctx, outerPath);
        CGContextFillPath(ctx);
        CGContextRestoreGState(ctx);
    }
    
    if (self.player.handle == @"Mostafa") {
        
        CGMutablePathRef outerPath = createRoundedRectForRect(outerRect, 10.0);
        CGContextSetFillColorWithColor(ctx, lighterTealColor); // outline
        CGContextFillRect(ctx, self.bounds);
        CGContextSaveGState(ctx);
        CGContextSetFillColorWithColor(ctx, tealColor); // fill
        CGContextAddPath(ctx, outerPath);
        CGContextFillPath(ctx);
        CGContextRestoreGState(ctx);
    }
    
    if (self.player.handle == @"Kristi") {
        
        CGMutablePathRef outerPath = createRoundedRectForRect(outerRect, 10.0);
        CGContextSetFillColorWithColor(ctx, lighterYellowColor); // outline
        CGContextFillRect(ctx, self.bounds);
        CGContextSaveGState(ctx);
        CGContextSetFillColorWithColor(ctx, yellowColor); // fill
        CGContextAddPath(ctx, outerPath);
        CGContextFillPath(ctx);
        CGContextRestoreGState(ctx);
    }
}
*/
@end
