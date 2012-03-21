//
//  MJResource.m
//  LandGrab!
//
//  Created by Andrew Huss on 3/1/12.
//  Copyright (c) 2012 Apple. All rights reserved.
//

#import "MJResource.h"
#import "MJBoard.h"
#import "MJTile.h"

@implementation MJResource

@synthesize coordinate = _coordinate;
@synthesize tiles = _tiles;

@synthesize value = _value;

- (id) initWithCoordinate:(CGPoint)aCoordinate {
    if ((self = [super initWithFrame:CGRectMake(aCoordinate.x * [MJBoard tileSize], aCoordinate.y * [MJBoard tileSize], 0, 0)]) == nil) {
		return self;
    }
	
	_coordinate = aCoordinate;
	_tiles = nil;
	_value = 0;
	[self setTilesWithCoordinateArray:[NSArray arrayWithObject:@"0,0"]];
    return self;
}

- (void) setTilesWithCoordinateArray:(NSArray*)coordinates {
	if (_tiles) {
		for (MJTile* t in _tiles) {
			[t removeFromSuperview];
		}
		_tiles = NULL;
	}
	CGSize size = self.frame.size;
	for (NSString* s in coordinates) {
		CGPoint p = CGPointFromString([NSString stringWithFormat:@"{%@}",s]);
		
		if (((p.x+1) * [MJBoard tileSize]) > size.width) size.width = (p.x+1) * [MJBoard tileSize];
		if (((p.y+1) * [MJBoard tileSize]) > size.height) size.height = (p.y+1) * [MJBoard tileSize];
		
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height)];
		
		MJTile* t = [[MJTile alloc] initWithCoordinate:p];
		[t setUserInteractionEnabled:NO];
		[t setBackgroundColor:[UIColor whiteColor]];
		[t setIsPlayed:YES];
		
		[self addTile:t];
	}
}

- (void) addTile:(MJTile*)tile {
	[_tiles addObject:tile];
	[self addSubview:tile];
}

//returns positive (value + 0-to-value) OR negative (0-to-value)
- (int) setRandomResourceValueWithValue:(int) value {
    NSUInteger randomInt = (arc4random() % 2) + 1;
    if (randomInt == 1) { //returns positive (value + 0-to-value)
        return (arc4random_uniform(value)) + value;
    }
    else { //negative (0-to-value)
        return -(arc4random_uniform(value));
    }
    
}

@end
