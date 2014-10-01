//
//  EventDetailViewController.h
//  SQuInt2014
//
//  Created by csjan on 9/10/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@class EventDetailViewController;

@interface EventDetailViewController : UIViewController

@property NSString *event_objid;
@property int from_author;
@property int event_type;  //talk=0, poster=1

@property (strong, nonatomic) IBOutlet UIView *eventdetail_card_view;
@property (strong, nonatomic) IBOutlet UIView *eventdetail_trim_view;
@property (strong, nonatomic) IBOutlet UILabel *eventdetail_name_label;
@property (strong, nonatomic) IBOutlet UILabel *eventdetail_author_label;
@property (strong, nonatomic) IBOutlet UILabel *eventdetail_location_label;
@property (strong, nonatomic) IBOutlet UILabel *eventdetail_time_label;
@property (strong, nonatomic) IBOutlet UILabel *eventdetail_description_label;
@property (strong, nonatomic) IBOutlet UIButton *eventdetail_authordetail_button;
- (IBAction)eventdetail_authordetail_button_tap:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *eventdetail_abstract_button;
- (IBAction)eventdetail_abstract_button_tap:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIView *eventdetail_description_card_view;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *nav_done_button;
- (IBAction)nav_done_button_tap:(UIBarButtonItem *)sender;



@end
