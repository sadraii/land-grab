//
//  MJBoard.m
//  LandGrab!
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJBoard.h"
#import "MJContainerView.h"
#import "MJBoard.h"
#import "MJPlayer.h"

#import "MJTile.h"

@implementation MJBoard

@synthesize pieces = _pieces;
@synthesize boardSize = _boardSize; 
@synthesize containerView = _containerView;
@synthesize tileSize = _tileSize;

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setPieces:NULL];
        _tileSize = 64;
        _boardSize = CGSizeMake(30, 30);
        _containerView = NULL;
        [self newGame];
        
    }
    return self;
}

- (void) newGame
{
    if(_containerView)
    {
        _containerView = NULL;
    }
    CGRect frame = CGRectMake(0, 0, _boardSize.width*_tileSize, _boardSize.height*_tileSize);
    NSLog(@"BoardSize: (%f, %f)", frame.size.width, frame.size.height);
    _containerView = [[MJContainerView alloc] initWithFrame:frame];
    _containerView.board = self;
    [self addSubview:_containerView];
}

- (void) setBoardSize:(CGSize)size
{
    
}

- (CGPoint) snapPieceToPoint:(MJPiece*)piece
{
    
}

- (void) scalePiece:(MJPiece*)piece
{
    
}

- (CGPoint) originOfPiece:(MJPiece*)piece
{
    
}

@end
