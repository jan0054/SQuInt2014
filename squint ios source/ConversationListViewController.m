//
//  ConversationListViewController.m
//  SQuInt2014
//
//  Created by csjan on 10/13/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "ConversationListViewController.h"
#import <Parse/Parse.h>
#import "ConversationCellTableViewCell.h"
#import "ChatViewController.h"
#import "UIColor+ProjectColors.h"

@interface ConversationListViewController ()

@end

NSString *chosen_conv_id;
NSString *chosen_conv_other_guy_id;
NSString *chosen_conv_other_guy_name;
PFUser *chosen_guy;

@implementation ConversationListViewController
@synthesize conversation_array;
@synthesize talked_to_array;
@synthesize talked_from_array;
@synthesize pullrefresh;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.conversation_list_table.tableFooterView = [[UIView alloc] init];
    self.conversation_array = [[NSMutableArray alloc] init];
    self.talked_to_array = [[NSMutableArray alloc] init];
    self.talked_from_array = [[NSMutableArray alloc] init];
    
    //Pull To Refresh Controls
    self.pullrefresh = [[UIRefreshControl alloc] init];
    [pullrefresh addTarget:self action:@selector(refreshctrl:) forControlEvents:UIControlEventValueChanged];
    [self.conversation_list_table addSubview:pullrefresh];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self get_conversations];
}

- (void) viewDidLayoutSubviews
{
    if ([self.conversation_list_table respondsToSelector:@selector(layoutMargins)]) {
        self.conversation_list_table.layoutMargins = UIEdgeInsetsZero;
    }
}

//called when pulling downward on the tableview
- (void)refreshctrl:(id)sender
{
    //refresh code here
    [self get_conversations];
    // End Refreshing
    [(UIRefreshControl *)sender endRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"TABLE COUNT: %lu", [self.conversation_array count]);
    return self.conversation_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConversationCellTableViewCell *conversationcell = [tableView dequeueReusableCellWithIdentifier:@"conversationcell"];
    if ([conversationcell respondsToSelector:@selector(layoutMargins)]) {
        conversationcell.layoutMargins = UIEdgeInsetsZero;
    }
    conversationcell.selectionStyle = UITableViewCellSelectionStyleNone;
    conversationcell.conversation_card_view.backgroundColor = [UIColor whiteColor];
    
    PFObject *conv = [self.conversation_array objectAtIndex:indexPath.row];
    PFObject *user_a = conv[@"user_a"];
    PFObject *user_b = conv[@"user_b"];
    PFUser *currentuser = [PFUser currentUser];
    if ([user_a.objectId isEqualToString:currentuser.objectId])
    {
        conversationcell.conversation_name_label.text = user_b[@"username"];
    }
    else if ([user_b.objectId isEqualToString:currentuser.objectId])
    {
        conversationcell.conversation_name_label.text = user_a[@"username"];
    }
    conversationcell.conversation_msg_label.text = conv[@"last_msg"];
    
    NSDate *date = conv[@"last_time"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"MMM-d HH:mm"];
    NSString *dateString = [dateFormat stringFromDate:date];
    conversationcell.conversation_time_label.text = dateString;
    
    return conversationcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *chosen_conv = [self.conversation_array objectAtIndex:indexPath.row];
    chosen_conv_id = chosen_conv.objectId;
    
    PFUser *cur_user = [PFUser currentUser];
    PFUser *user_a = chosen_conv[@"user_a"];
    PFUser *user_b = chosen_conv[@"user_b"];
    if ([user_a.objectId isEqualToString:cur_user.objectId])
    {
        chosen_conv_other_guy_id = user_b.objectId;
        chosen_conv_other_guy_name = user_b[@"username"];
        chosen_guy = user_b;
    }
    else if ([user_b.objectId isEqualToString:cur_user.objectId])
    {
        chosen_conv_other_guy_id = user_a.objectId;
        chosen_conv_other_guy_name = user_a[@"username"];
        chosen_guy = user_a;
    }
    
    [self performSegueWithIdentifier:@"chatsegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ChatViewController *destination = [segue destinationViewController];
    destination.conversation_objid = chosen_conv_id;
    destination.is_new_conv = 0;
    destination.other_guy_objid = chosen_conv_other_guy_id;
    destination.other_guy_name = chosen_conv_other_guy_name;
    destination.otherguy = chosen_guy;
    
}

- (void) get_conversations
{
    [self.conversation_array removeAllObjects];
    
    PFUser *currentuser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"conversation"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user_a"];
    [query includeKey:@"user_b"];
    [query whereKey:@"user_a" equalTo:currentuser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"conversation query success with count: %lu", (unsigned long)[objects count]);
        for (PFObject *object in objects)
        {
            [self.conversation_array addObject:object];
            //[self.talked_from_array addObject:object];
        }
        [self.conversation_list_table reloadData];
        NSLog(@"TABLE RELOADED");
    }];
    PFQuery *query_two = [PFQuery queryWithClassName:@"conversation"];
    [query_two orderByDescending:@"createdAt"];
    [query_two includeKey:@"user_a"];
    [query_two includeKey:@"user_b"];
    [query_two whereKey:@"user_b" equalTo:currentuser];
    [query_two findObjectsInBackgroundWithBlock:^(NSArray *objectss, NSError *error) {
        NSLog(@"conversation query two success with count: %lu", (unsigned long)[objectss count]);
        for (PFObject *object in objectss)
        {
            [self.conversation_array addObject:object];
            //[self.talked_to_array addObject:object];
        }
        [self.conversation_list_table reloadData];
        NSLog(@"TABLE RELOADED");
    }];


}

- (IBAction)back_to_people_button_tap:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
