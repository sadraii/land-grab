//
//  MAKJAMMasterViewController.h
//  Test
//
//  Created by Andrew Huss on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAKJAMDetailViewController;

#import <CoreData/CoreData.h>

@interface MAKJAMMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) MAKJAMDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
