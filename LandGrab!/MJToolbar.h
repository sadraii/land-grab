//
//  MJToolbar.h
//  LandGrab!
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJViewController;
@class MJPlayer;
@class MJTile;
@class MJInventoryCount;

@interface MJToolbar : UIView {
@public
	
@private
	CGFloat offset;
	CGFloat pieceHeight;
	NSUInteger maxX;
}

@property (weak, nonatomic) IBOutlet    MJViewController*   viewController;
@property (weak, nonatomic)             MJPlayer*           player;
@property (strong, nonatomic)           NSMutableArray*     pieces;
@property (strong, nonatomic)           MJInventoryCount*   inventoryCounter;

- (void) newGame;
- (void) loadPlayer:(MJPlayer*) player;
- (void) removeAllPieces;
- (void) addTile:(MJTile*)tile;
- (void) updateCounterWith:(NSUInteger)number;
- (void) placeAnotherTile:(MJPlayer*) player;
- (void) animateInventoryCounter;
- (void) fadeInventoryCounter;
@end