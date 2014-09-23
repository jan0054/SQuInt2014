//
//  PositionDetailViewController.m
//  SQuInt2014
//
//  Created by csjan on 4/21/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "PositionDetailViewController.h"

@interface PositionDetailViewController ()

@end

PFObject *thecareer;

@implementation PositionDetailViewController
@synthesize career_objid;


- (void)viewDidLoad
{
    [super viewDidLoad];
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
    self.career_posted_by.text = [NSString stringWithFormat:@"%@ %@", person[@"first_name"], person[@"last_name"]];
}

@end
