//
//  MJPiece.m
//  LandGrab!
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJPiece.h"
#import "MJTile.h"
#import "MJViewController.h"
#import "MJPlayer.h"

@implementation MJPiece

@synthesize viewController = _viewController;
@synthesize superview = _superview;
@synthesize player = _player;
@synthesize size = _size;
@synthesize tiles = _tiles;
@synthesize rotation = _rotation;
@synthesize image = _image;
@synthesize name = _name;
@synthesize isPlayed = _isPlayed;

- (id)init {
    self = [super init];
    if (self) {
        _player = nil;
        _size = CGSizeZero;
        _isPlayed = NO;
    }
    return self;
}

- (void) setOrigin:(CGPoint)point
{
    
}

/*
- (CGPoint) origin
{
    
}
*/
 
- (void) moveTiles:(CGSize) distance
{
    
}

- (void) snapToPoint
{
    
}

- (void) addAsSubviewToView:(UIView*)view
{
    
}

- (void) removeFromSuperview
{
    
}

- (void) loadDefaultTiles
{
    
}

- (void) addTile:(MJTile*)tile
{
    
}

- (void) revertToStartingSize
{
    
}

- (void) setScale:(CGFloat)scale
{
    
}

- (void) touchesBegan:(CGPoint)point
{
    
}

- (void) touchesMoved:(CGSize)distance
{
    
}

- (void) touchesEnded:(CGPoint)point
{
    
}

- (void) touchesCanceled:(CGSize)distanceTraveled
{
    
}

@end
