//
//  TravelTabViewController.h
//  SQuInt2014
//
//  Created by csjan on 4/17/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VenueCellTableViewCell.h"
#import <Parse/Parse.h>

@interface TravelTabViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *venuetable;
@property NSMutableArray *venue_array;

@end
