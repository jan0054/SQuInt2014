//
//  EventDetailViewController.m
//  SQuInt2014
//
//  Created by csjan on 9/10/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "EventDetailViewController.h"
#import "UIColor+ProjectColors.h"

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController
@synthesize event_objid;



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor reallylight_blue]];
    [self.eventdetail_card_view setBackgroundColor:[UIColor main_blue]];
    [self.eventdetail_trim_view setBackgroundColor:[UIColor main_orange]];
    [self.eventdetail_description_card_view setBackgroundColor:[UIColor shade_blue]];
    self.eventdetail_card_view.layer.cornerRadius = 5;
    self.eventdetail_description_card_view.layer.cornerRadius = 3;
    if (self.event_type ==0)
    {
        [self get_talk_data];
    }
    else if (self.event_type==1)
    {
        [self get_poster_data];
    }
}

-(void) get_talk_data
{
    PFQuery *query = [PFQuery queryWithClassName:@"talk"];
    [query includeKey:@"author"];
    [query includeKey:@"location"];
    [query getObjectInBackgroundWithId:self.event_objid block:^(PFObject *object, NSError *error) {
        NSLog(@"talk query success");
        self.eventdetail_name_label = object[@"name"];
        PFObject *author = object[@"author"];
        self.eventdetail_author_label.text = [NSString stringWithFormat:@"%@ %@", author[@"first_name"], author[@"last_name"]];
        self.eventdetail_description_label.text = object[@"description"];
        PFObject *location = object[@"location"];
        self.eventdetail_location_label.text = location[@"name"];
        NSDate *date = object[@"start_time"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat: @"MM/dd HH:mm"];
        NSString *dateString = [dateFormat stringFromDate:date];
        self.eventdetail_time_label.text = dateString;
        
    }];

}

- (void) get_poster_data
{
    PFQuery *query = [PFQuery queryWithClassName:@"poster"];
    [query includeKey:@"author"];
    [query includeKey:@"location"];
    [query getObjectInBackgroundWithId:self.event_objid block:^(PFObject *object, NSError *error) {
        NSLog(@"talk query success");
        self.eventdetail_name_label = object[@"name"];
        PFObject *author = object[@"author"];
        self.eventdetail_author_label.text = [NSString stringWithFormat:@"%@ %@", author[@"first_name"], author[@"last_name"]];
        self.eventdetail_description_label.text = object[@"description"];
        PFObject *location = object[@"location"];
        self.eventdetail_location_label.text = location[@"name"];
        
        self.eventdetail_time_label.text = @"";
        
    }];

}


- (IBAction)eventdetail_authordetail_button_tap:(UIButton *)sender {
}

- (IBAction)eventdetail_abstract_button_tap:(UIButton *)sender {
}


- (IBAction)nav_done_button_tap:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
