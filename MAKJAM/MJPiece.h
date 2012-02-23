//
//  MJPiece.h
//  MAKJAM
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJTileDelegate.h"
#import "MJPieceDelegate.h"

@class MJTile;

@interface MJPiece : NSObject <MJTileDelegate> {
	CGPoint coordinate;
	NSMutableArray* tiles;
	NSInteger rotation;
	UIImage* image;
	NSString* name;
}

@property (strong, nonatomic) id <MJPieceDelegate> delegate;
@property (readwrite) CGPoint coordinate;
@property (strong, nonatomic) NSMutableArray* tiles;
@property (readwrite) NSInteger rotation;
@property (strong, nonatomic) UIImage* image;
@property (strong, nonatomic) NSString* name;

- (id) initWithCoordinate:(CGPoint) aCoordinate tiles:(NSArray*)aTiles image:(UIImage*)aImage andName:(NSString*)aName;
- (void) setOrigin:(CGPoint)origin;
- (void) moveTiles:(CGSize)distance;

@end
