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
#import "EventDetailViewController.h"

@interface PeopleTabViewController : UIViewController 
@property (strong, nonatomic) IBOutlet UITableView *peopletable;
@property NSMutableArray *person_array;
- (IBAction)person_detail_button_tap:(UIButton *)sender;
@property int from_event;
@property NSString *event_author_id;
@property (strong, nonatomic) IBOutlet UIButton *chat_float;
- (IBAction)chat_float_tap:(UIButton *)sender;

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;

@end
