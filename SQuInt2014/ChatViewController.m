//
//  ChatViewController.m
//  SQuInt2014
//
//  Created by csjan on 4/21/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController
@synthesize is_new_conv;
@synthesize conversation_objid;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *chatmecell = [tableView dequeueReusableCellWithIdentifier:@"chatmecell"];
    
    UITableViewCell *chatyoucell = [tableView dequeueReusableCellWithIdentifier:@"chatyoucell"];
    
    chatmecell.selectionStyle = UITableViewCellSelectionStyleNone;
    chatyoucell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row==0)
    {
        return chatmecell;
    }
    else
    {
        return chatyoucell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)send_chat_button_tap:(UIButton *)sender {
}
@end
