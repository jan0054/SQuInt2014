//
//  PersonDetailViewController.h
//  SQuInt2014
//
//  Created by csjan on 4/22/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *person_detail_table;
- (IBAction)person_detail_seg_action:(UISegmentedControl *)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *person_detail_seg;
@property (strong, nonatomic) IBOutlet UIImageView *person_photo;
@property (strong, nonatomic) IBOutlet UILabel *person_name_label;
@property (strong, nonatomic) IBOutlet UILabel *person_institution_label;
@property (strong, nonatomic) IBOutlet UIButton *person_email_button;
@property (strong, nonatomic) IBOutlet UIButton *person_link_button;
- (IBAction)person_email_button_tap:(UIButton *)sender;
- (IBAction)person_link_button_tap:(UIButton *)sender;

@end
