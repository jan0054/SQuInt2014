//
//  ConversationListViewController.h
//  SQuInt2014
//
//  Created by csjan on 10/13/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ConversationListViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIBarButtonItem *back_to_people_button;
- (IBAction)back_to_people_button_tap:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UITableView *conversation_list_table;

@property NSMutableArray *conversation_array;
@property NSMutableArray *talked_to_array;
@property NSMutableArray *talked_from_array;

@property UIRefreshControl *pullrefresh;

@end
