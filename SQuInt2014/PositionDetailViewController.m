//
//  PositionDetailViewController.m
//  SQuInt2014
//
//  Created by csjan on 4/21/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "PositionDetailViewController.h"
#import "UIColor+ProjectColors.h"

@interface PositionDetailViewController ()

@end

PFObject *thecareer;
NSString *postermail;

@implementation PositionDetailViewController
@synthesize career_objid;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //styling
    self.view.backgroundColor = [UIColor reallylight_blue];
    self.career_card_view.backgroundColor = [UIColor main_blue];
    self.career_trim_view.backgroundColor =[UIColor main_orange];
    self.note_card_view.backgroundColor = [UIColor shade_blue];
    self.career_card_view.layer.cornerRadius = 5;
    self.note_card_view.layer.cornerRadius = 3;
    self.contact_poster_button.titleLabel.textColor = [UIColor bright_orange];
    //self.career_trim_view.layer.cornerRadius = 5;
    
    [self get_career_data];

}

- (void) get_career_data
{
    PFQuery *careerquery = [PFQuery queryWithClassName:@"career"];
    [careerquery includeKey:@"posted_by"];
    [careerquery getObjectInBackgroundWithId:self.career_objid block:^(PFObject *object, NSError *error) {
        NSLog(@"detail career query success");
        thecareer = object;
        [self fill_data];
    }];
}

- (void) fill_data
{
    self.career_position_label.text = thecareer[@"position"];
    self.career_institution_label.text = thecareer[@"institution"];
    self.career_notes.text = thecareer[@"note"];
    PFObject *person = thecareer[@"posted_by"];
    postermail = person[@"email"];
    self.career_posted_by.text = [NSString stringWithFormat:@"Posted by: %@ %@", person[@"first_name"], person[@"last_name"]];
}

- (IBAction)contact_poster_button_tap:(UIButton *)sender {
    NSString *mailstr = [NSString stringWithFormat:@"mailto://%@", postermail];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailstr]];
}
@end
