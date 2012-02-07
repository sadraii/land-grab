//
//  MJRootScene.m
//  MAKJAM
//
//  Created by Andrew Huss on 2/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MJRootScene.h"


@implementation MJRootScene

-(id) init {
    if ((self = [super init]) == nil) {
		return self;
    }
    glClearColor(0.1f, 0.1f, 0.3f, 1.0f);
	
	// "empty" as in "minimal code & resources"
	CCLabelTTF* label = [CCLabelTTF labelWithString:@"Empty Project"
										   fontName:@"Arial"
										   fontSize:40];
	label.position = [CCDirector sharedDirector].screenCenter;
	label.color = ccCYAN;
	[self addChild:label];
    return self;
}

- (BOOL) handleDroppedPiece:(MJPieceImageView *)piece {
	CCLOG(@"%@: %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
	CCSprite* tmp = [[CCSprite alloc] initWithFile:@"Piece_right.png"];
	[tmp setPosition:[[CCDirector sharedDirector] convertToGL:piece.center]];
	NSLog(@"Added sprite: %f, %f",tmp.position.x, tmp.position.y);
	[self addChild:tmp];
	return true;
}

@end
