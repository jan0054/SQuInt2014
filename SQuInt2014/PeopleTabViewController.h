//
//  PeopleTabViewController.h
//  SQuInt2014
//
//  Created by csjan on 4/17/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SelfCellTableViewCell.h"
#import "PersonCellTableViewCell.h"

@interface PeopleTabViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *peopletable;
@property NSMutableArray *person_array;

@end
