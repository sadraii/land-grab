//
//  MJToolbar.m
//  MAKJAM
//
//  Created by Andrew Huss on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MJToolbar.h"

@implementation MJToolbar
@synthesize toolbarHeight = _toolbarHeight;
@synthesize pieces = _pieces;

-(id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame]) == nil) {
		return self;
    }
	[self setToolbarHeight:100];
    [self setBackgroundColor:[UIColor whiteColor]];
	[self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    return self;
}

- (void) setNeedsDisplay {
	[super setNeedsDisplay];
	
	NSLog(@"MJToolbar: %@", NSStringFromSelector(_cmd));
}

- (void) setToolbarHeight:(CGFloat)toolbarHeight {
	NSLog(@"Chaning toolbar height");
	CGRect frame = self.frame;
	if (frame.origin.y) {
		frame.origin.y += (_toolbarHeight - toolbarHeight);
	}
	_toolbarHeight = toolbarHeight;
	frame.size.height = _toolbarHeight;
}

- (void) createDebugPieces {
	float height = self.frame.size.height - (2.0f * offset);
	for (int i = 0; i < 10; i++) {
		MJPieceImageView* piece = [[MJPieceImageView alloc] initWithFrame:CGRectMake(offset + maxX, offset, height, height)];
		//		furthestRight += piece.frame.size.width + offset;
		switch (i % 3) {
			case 0:
				[piece setBackgroundColor:[UIColor redColor]];
				break;
			case 1:
				[piece setBackgroundColor:[UIColor whiteColor]];
				break;
			case 2:
				[piece setBackgroundColor:[UIColor blueColor]];
				break;
				
			default:
				break;
		}
		
//		[piece setBackgroundView:_pvc.view];
//		[piece setBoard:_pvc.board];
//		[piece setToolbar:_pvc.toolbar];
		
//		[piece setDelegate:_pvc.board];
		
		[self addPiece:piece];
	}
	
}

- (void) addPiece:(MJPieceImageView*)piece {
	if (!piece) {
		return;
	}
	int index= 0;
	for (MJPieceImageView* p in _pieces) {
		if (piece.center.x <= p.center.x) break;
		++index;
	}
	NSLog(@"Added Piece at index: %i", index);
	[_pieces insertObject:piece atIndex:index];
	[self reloadToolbarStartingAtIndex:index];
}

- (void) removePiece:(MJPieceImageView*)piece {
	//	furthestRight -= piece.frame.size.width + offset;
	//	[piece removeFromSuperview];
	int index = [_pieces indexOfObject:piece];
	NSLog(@"Removing piece at index: %i", _pieces.count);
	[_pieces removeObject:piece];
	
	[self reloadToolbarStartingAtIndex:index];
	
	//	NSLog(@"Remove: %i", _pieces.count);
}

- (void) reloadToolbarStartingAtIndex:(NSUInteger)index {
	NSLog(@"Reloading Toolbar at Index: %i", index);
//	NSArray* tmp = [NSArray arrayWithArray:
//					[_pieces objectsAtIndexes:
//					 [NSIndexSet indexSetWithIndexesInRange:
//					  NSMakeRange(index, _pieces.count-index-1)]]];
	NSArray* tmp = [NSArray arrayWithArray:_pieces];
	[_pieces removeObjectsInArray:tmp];
	MJPieceImageView* lastObj = _pieces.lastObject;
	maxX = lastObj.frame.origin.x + lastObj.frame.size.width;
	
	for (MJPieceImageView* p in tmp) {
		[p removeFromSuperview];
		[p setFrame:CGRectMake(maxX + offset, 
							   offset, 
							   p.frame.size.width, 
							   p.frame.size.height)];
		[self addSubview:p];
		maxX += p.frame.size.width + offset;
		[self setContentSize:CGSizeMake(maxX + offset, self.frame.size.height)];
		[_pieces addObject:p];
	}
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	NSLog(@"Will Begin Dragging");
}

@end
