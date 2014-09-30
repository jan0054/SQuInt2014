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
        
    }];

}


- (IBAction)eventdetail_authordetail_button_tap:(UIButton *)sender {
}

- (IBAction)eventdetail_abstract_button_tap:(UIButton *)sender {
}
@end
