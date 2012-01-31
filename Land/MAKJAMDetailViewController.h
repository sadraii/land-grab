//
//  MAKJAMDetailViewController.h
//  Land
//
//  Created by Andrew Huss on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//Andrew edited a file

#import <UIKit/UIKit.h>

@interface MAKJAMDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
