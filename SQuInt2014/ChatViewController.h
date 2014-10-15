//
//  ChatViewController.h
//  SQuInt2014
//
//  Created by csjan on 4/21/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController
@property NSString *conversation_objid;
@property int is_new_conv;

@property (strong, nonatomic) IBOutlet UITextField *chat_input_box;
@property (strong, nonatomic) IBOutlet UIButton *send_chat_button;
- (IBAction)send_chat_button_tap:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITableView *chat_table;


@end
