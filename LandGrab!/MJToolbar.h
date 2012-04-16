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
@class MJBombTile;

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
@property (strong, nonatomic)           MJInventoryCount*   bombCounter;
@property (strong, nonatomic)           MJBombTile*         realBombTile;

- (void) newGame;
- (void) loadPlayer:(MJPlayer*) player;
- (void) removeAllPiecesFor:(MJPlayer*)player;
- (void) addTile:(MJTile*)tile;
- (void) updateCounterWith:(NSUInteger)number;
- (void) placeAnotherTile:(MJPlayer*) player;
- (void) animateInventoryCounter;
- (void) fadeInventoryCounter;
- (void) addBombToToolBar:(MJPlayer*) player;
- (void) updateBombCounterForPlayer:(MJPlayer*)player;
- (void) animateBombCounter;
- (void) fadeBombCounter;
- (void) addBombTile:(MJBombTile*)tile;

@end