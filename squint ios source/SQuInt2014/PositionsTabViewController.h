//
//  PositionsTabViewController.h
//  SQuInt2014
//
//  Created by csjan on 4/17/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CareerCellTableViewCell.h"

@interface PositionsTabViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *careertable;
@property NSMutableArray *career_array;
- (IBAction)career_detail_tap:(UIButton *)sender;

@end
