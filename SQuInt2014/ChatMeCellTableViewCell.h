//
//  ChatMeCellTableViewCell.h
//  SQuInt2014
//
//  Created by csjan on 10/15/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatMeCellTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *chat_cell_background_view;
@property (strong, nonatomic) IBOutlet UILabel *chat_time_label;
@property (strong, nonatomic) IBOutlet UILabel *chat_content_label;
@property (strong, nonatomic) IBOutlet UIView *chat_content_background_view;

@end
