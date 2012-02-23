//
//  MJPiece.m
//  MAKJAM
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJPiece.h"
#import "MJTile.h"

@implementation MJPiece

@synthesize delegate = _delegate;
@synthesize coordinate = _coordinate;
@synthesize tiles = _tiles;
@synthesize rotation = _rotation;
@synthesize image = _image;
@synthesize name = _name;

-(id) init {
    if ((self = [super init]) == nil) {
		return self;
    }
	_coordinate = CGPointZero;
	_tiles = [[NSMutableArray alloc] init];
	_rotation = 0;
	_image = nil;
	_name = nil;
    return self;
}

- (id) initWithCoordinate:(CGPoint) aCoordinate tiles:(NSArray*)aTiles image:(UIImage*)aImage andName:(NSString*)aName {
	if ((self = [super init]) == nil) {
		return self;
    }
	_coordinate = aCoordinate;
	_tiles = [NSMutableArray arrayWithArray:aTiles];
	_rotation = 0;
	_image = aImage;
	_name = aName;
    return self;
}

#pragma mark - Class Methods
- (void) setOrigin:(CGPoint)origin {
	CGSize distance = CGSizeMake(<#CGFloat width#>, <#CGFloat height#>)
}
- (void) moveTiles:(CGSize)distance {
	
}

#pragma mark - MJTileDelegate Methods
- (void) touchesBegan:(CGPoint)point {
	//Highlight piece
}
- (void) touchesMoved:(CGSize)distance {
	for (MJTile* t in _tiles) {
		[t setFrame:CGRectMake(t.frame.origin.x + distance.width, t.frame.origin.y + distance.height, t.frame.size.width, t.frame.size.height)];
	}
}
- (void) touchesEnded:(CGPoint)point {
	[_delegate addPiece:self];
}
- (void) touchesCanceled: (CGSize)distanceTraveled {
	
}


@end
