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
PFUser *otherguy;

@implementation ChatViewController
@synthesize is_new_conv;
@synthesize conversation_objid;
@synthesize chat_array;
@synthesize chat_table_array;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.chat_input_box.delegate = self;
    self.chat_array = [[NSMutableArray alloc] init];
    self.chat_table_array = [[NSMutableArray alloc] init];
    
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
- (void) textViewDidBeginEditing:(UITextView *)textView
{
    [self animateTextField: textView up: YES];
}
- (void) textViewDidEndEditing:(UITextView *)textView
{
    [self animateTextField: textView up: NO];
}
- (void) animateTextField: (UITextView *) textView up: (BOOL) up
{
    const int movementDistance = 216; // sliding distance
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
        chatyoucell.chat_person_label.text = self.other_guy_name;
        return chatyoucell;
    }
    else
    {
        //msg is me to them
        chatmecell.chat_content_label.text = [chat_dict objectForKey:@"content"];
        return chatmecell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void) get_chat_info
{
    if (self.is_new_conv==0)
    {
        PFObject *the_conv = [PFObject objectWithoutDataWithClassName:@"conversation" objectId:self.conversation_objid];
        conversation = the_conv;
        
        PFQuery *query = [PFQuery queryWithClassName:@"chat"];
        [query whereKey:@"conversation" equalTo:the_conv];
        [query includeKey:@"from"];
        [query includeKey:@"to"];
        [query orderByAscending:@"createdAt"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            NSLog(@"chat query success");
            self.chat_array = [objects mutableCopy];
            for (PFObject *chat_obj in objects)
            {
                NSDate *msg_time = chat_obj[@"createdAt"];
                NSMutableDictionary *chat_dict = [[NSMutableDictionary alloc] init];
                [chat_dict setObject:chat_obj[@"content"] forKey:@"content"];
                [chat_dict setObject:msg_time forKey:@"date"];
                PFUser *from_person = chat_obj[@"from"];
                PFUser *to_person = chat_obj[@"to"];
                NSString *from_id = from_person.objectId;
                PFUser *self_user = [PFUser currentUser];
                NSString *self_id =self_user.objectId;
                if ([from_id isEqualToString:self_id])
                {
                    [chat_dict setValue:[NSNumber numberWithInt:1] forKey:@"fromme"];
                    otherguy = to_person;
                }
                else
                {
                    [chat_dict setValue:[NSNumber numberWithInt:0] forKey:@"fromme"];
                    otherguy = from_person;
                }
                
                [self.chat_table_array addObject:chat_dict];
            }
            [self.chat_table reloadData];
        }];
    }
    else if (self.is_new_conv==1)
    {
        
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
