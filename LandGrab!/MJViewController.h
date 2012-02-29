//
//  MJViewController.h
//  LandGrab!
//
//  Created by Andrew Huss on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJTopBar;
@class MJBoard;
@class MJToolbar;

@class MJPlayer;
@class MJPiece;
@class MJTile;

@interface MJViewController : UIViewController {
	NSInteger currentPlayerIndex;
	NSUInteger turnCount;
}
@property (strong, nonatomic) IBOutlet MJTopBar* topbar;
@property (strong, nonatomic) IBOutlet UILabel* handle;
@property (strong, nonatomic) IBOutlet UILabel *territory;
@property (strong, nonatomic) IBOutlet MJBoard* board;
@property (strong, nonatomic) IBOutlet MJToolbar* toolbar;

@property (strong, nonatomic) NSMutableArray* players;
@property (weak, nonatomic) MJPlayer* currentPlayer;

- (IBAction)newGame:(id)sender;
- (IBAction)zoomToCapital:(id)sender;
- (void) zoomToRect:(CGRect)rect;
- (void) nextPlayer;

- (void) addTile:(MJTile*)tile;
- (void) addPiece:(MJPiece*)piece;

@end
