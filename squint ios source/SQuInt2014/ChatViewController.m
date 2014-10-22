//
//  ChatViewController.m
//  SQuInt2014
//
//  Created by csjan on 4/21/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "ChatViewController.h"
#import "UIColor+ProjectColors.h"
#import "ChatMeCellTableViewCell.h"
#import "ChatYouCellTableViewCell.h"

@interface ChatViewController ()

@end

PFObject *conversation;


@implementation ChatViewController
@synthesize is_new_conv;
@synthesize conversation_objid;
@synthesize chat_array;
@synthesize chat_table_array;
@synthesize otherguy;
@synthesize pullrefresh;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.chat_input_box.delegate = self;
    self.chat_array = [[NSMutableArray alloc] init];
    self.chat_table_array = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.chat_table.backgroundColor = [UIColor clearColor];
    self.send_chat_button.titleLabel.textColor = [UIColor nu_bright_orange];
    
    //Pull To Refresh Controls
    self.pullrefresh = [[UIRefreshControl alloc] init];
    [pullrefresh addTarget:self action:@selector(refreshctrl:) forControlEvents:UIControlEventValueChanged];
    [self.chat_table addSubview:pullrefresh];
    
}



//called when pulling downward on the tableview
- (void)refreshctrl:(id)sender
{
    //refresh code here
    [self get_chat_info];
    // End Refreshing
    [(UIRefreshControl *)sender endRefreshing];
}

//dismiss keyboard when touched outside
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.chat_input_box isFirstResponder] && [touch view] != self.chat_input_box) {
        [self.chat_input_box resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

//controls view sliding up when editing text field
- (void) textFieldDidBeginEditing:(UITextField *)textView
{
    [self animateTextField: textView up: YES];
}
- (void) textFieldDidEndEditing:(UITextField *)textView
{
    [self animateTextField: textView up: NO];
}
- (void) animateTextField: (UITextField *) textView up: (BOOL) up
{
    const int movementDistance = 197; // sliding distance
    const float movementDuration = 0.3f;
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

    [self get_chat_info];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"chat table count: %ld",[self.chat_table_array count]);
    return [self.chat_table_array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatMeCellTableViewCell *chatmecell = [tableView dequeueReusableCellWithIdentifier:@"chatmecell"];
    ChatYouCellTableViewCell *chatyoucell = [tableView dequeueReusableCellWithIdentifier:@"chatyoucell"];
    
    chatmecell.selectionStyle = UITableViewCellSelectionStyleNone;
    chatyoucell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableDictionary *chat_dict = [self.chat_table_array objectAtIndex:indexPath.row];
    NSNumber *fromme_nsnum = [chat_dict valueForKey:@"fromme"];
    int fromme = [fromme_nsnum intValue];
    if (fromme==0)
    {
        //msg is them to me
        chatyoucell.chat_content_label.text = [chat_dict objectForKey:@"content"];
        chatyoucell.chat_time_label.text = [chat_dict objectForKey:@"time"];
        chatyoucell.chat_person_label.text = self.other_guy_name;
        return chatyoucell;
    }
    else
    {
        //msg is me to them
        chatmecell.chat_content_label.text = [chat_dict objectForKey:@"content"];
        chatmecell.chat_time_label.text = [chat_dict objectForKey:@"time"];
        return chatmecell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //do nothing when tapping chat elements (yet)
}

- (void) get_chat_info
{
    //reset the arrays used to store chat elements
    [self.chat_table_array removeAllObjects];
    [self.chat_array removeAllObjects];
    
    if (self.is_new_conv==0)
    {
        NSLog(@"IS_NEW_CONV 0");
        PFObject *the_conv = [PFObject objectWithoutDataWithClassName:@"conversation" objectId:self.conversation_objid];
        conversation = the_conv;
        
        PFQuery *query = [PFQuery queryWithClassName:@"chat"];
        [query whereKey:@"conversation" equalTo:the_conv];
        [query includeKey:@"from"];
        [query includeKey:@"to"];
        [query orderByAscending:@"createdAt"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            NSLog(@"chat query success with # of chat elements: %ld", [objects count]);
            
            //self.chat_array = [objects mutableCopy];
            
            //loop for each chat element
            for (PFObject *chat_obj in objects)
            {
                NSLog(@"FOR LOOP - chat objects");
                
                NSDate *msg_time = chat_obj.createdAt;
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat: @"MM-dd HH:mm"];
                NSString *dateString = [dateFormat stringFromDate:msg_time];
                NSLog(@"DATE:%@", dateString);
                NSMutableDictionary *chat_dict = [[NSMutableDictionary alloc] init];
                
                [chat_dict setObject:chat_obj[@"content"] forKey:@"content"];
                [chat_dict setObject:dateString forKey:@"time"];
                PFUser *from_person = chat_obj[@"from"];
                PFUser *to_person = chat_obj[@"to"];
                NSString *from_id = from_person.objectId;
                PFUser *self_user = [PFUser currentUser];
                NSString *self_id =self_user.objectId;
                if ([from_id isEqualToString:self_id])
                {
                    [chat_dict setValue:[NSNumber numberWithInt:1] forKey:@"fromme"];
                    NSLog(@"msg is from me");
                }
                else
                {
                    [chat_dict setValue:[NSNumber numberWithInt:0] forKey:@"fromme"];
                    NSLog(@"msg is from other guy");
                }
                
                [self.chat_table_array addObject:chat_dict];
            }
            
            [self.chat_table reloadData];
            NSLog(@"CHAT_TABLE ARRAY: %@", self.chat_table_array);
            
        }];
    }
    else if (self.is_new_conv==1)
    {
        PFObject *the_conv = [PFObject objectWithoutDataWithClassName:@"conversation" objectId:self.conversation_objid];
        conversation = the_conv;
        NSLog(@"IS_NEW_CONV 1");
        
    }
        
}



- (IBAction)send_chat_button_tap:(UIButton *)sender {
    NSString *content = self.chat_input_box.text;
    NSDate *chat_date = [NSDate date];

    /*
    NSMutableDictionary *chat_dict = [[NSMutableDictionary alloc] init];
    [chat_dict setObject:content forKey:@"content"];
    [chat_dict setValue:[NSNumber numberWithInt:1] forKey:@"fromme"];
    [chat_dict setObject:chat_date forKey:@"date"];
    */
    PFObject *new_chat = [PFObject objectWithClassName:@"chat"];
    new_chat[@"content"] = content;
    new_chat[@"conversation"] = conversation;
    new_chat[@"from"] = [PFUser currentUser];
    new_chat[@"to"] = otherguy;
    [new_chat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"new chat uploaded successfully");
        [self get_chat_info];
    }];
    
    self.chat_input_box.text = @"";
    self.chat_input_box.placeholder = @"Type message here..";
    
}




@end
