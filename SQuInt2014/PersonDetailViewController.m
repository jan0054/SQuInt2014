//
//  PersonDetailViewController.m
//  SQuInt2014
//
//  Created by csjan on 4/22/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "PersonDetailViewController.h"
#import "PersonDetailEventCellTableViewCell.h"
#import "UIColor+ProjectColors.h"

@interface PersonDetailViewController ()

@end

PFObject *the_person;
NSMutableArray *person_talks;
NSMutableArray *person_posters;
NSMutableArray *person_abstracts;
int seg_index;

@implementation PersonDetailViewController
@synthesize person_objid;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //initialize
    person_talks = [[NSMutableArray alloc] init];
    person_posters = [[NSMutableArray alloc] init];
    person_abstracts = [[NSMutableArray alloc] init];
    seg_index=0;
    
    //styling
    self.person_detail_table.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor reallylight_blue];
}

- (void) viewDidLayoutSubviews
{
    if ([self.person_detail_table respondsToSelector:@selector(layoutMargins)]) {
        self.person_detail_table.layoutMargins = UIEdgeInsetsZero;
    }
}


- (IBAction)person_detail_seg_action:(UISegmentedControl *)sender {
    seg_index = self.person_detail_seg.selectedSegmentIndex;
    [self.person_detail_table reloadData];
}
- (IBAction)person_email_button_tap:(UIButton *)sender {
    NSString *mailstr = the_person[@"email"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailstr]];
}

- (IBAction)person_link_button_tap:(UIButton *)sender {
    NSString *linkstr = the_person[@"link"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkstr]];
}

- (void) get_person_data
{
    PFQuery *personquery = [PFQuery queryWithClassName:@"person"];
    [personquery includeKey:@"user"];
    [personquery getObjectInBackgroundWithId:self.person_objid block:^(PFObject *object, NSError *error) {
        NSLog(@"detail person query success");
        the_person = object;
        [self get_person_talks];
        [self get_person_posters];
        [self get_person_abstracts];
    }];
}

- (void) get_person_talks
{
    PFQuery *person_talk_query = [PFQuery queryWithClassName:@"talk"];
    [person_talk_query whereKey:@"author" equalTo:the_person];
    [person_talk_query orderByDescending:@"start_time"];
    [person_talk_query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            NSLog(@"Successfully retrieved %lu talks for the person.", (unsigned long)objects.count);
            person_talks = [objects mutableCopy];
        }
        else
        {
            // Log details of the failure if there's an error
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void) get_person_posters
{
    PFQuery *person_poster_query = [PFQuery queryWithClassName:@"poster"];
    [person_poster_query whereKey:@"author" equalTo:the_person];
    [person_poster_query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            NSLog(@"Successfully retrieved %lu posters for the person.", (unsigned long)objects.count);
            person_posters = [objects mutableCopy];
        }
        else
        {
            // Log details of the failure if there's an error
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void) get_person_abstracts
{
    PFQuery *person_abstract_query = [PFQuery queryWithClassName:@"abstract"];
    [person_abstract_query whereKey:@"author" equalTo:the_person];
    [person_abstract_query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            NSLog(@"Successfully retrieved %lu abstracts for the person.", (unsigned long)objects.count);
            person_abstracts = [objects mutableCopy];
        }
        else
        {
            // Log details of the failure if there's an error
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (seg_index) {
        case 0:
            return [person_talks count];
            break;
        case 1:
            return [person_posters count];
            break;
        case 2:
            return [person_abstracts count];
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonDetailEventCellTableViewCell *persondetailcell = [tableView dequeueReusableCellWithIdentifier:@"persondetailcell"];
    
    if (seg_index==0)
    {
        PFObject *talk = [person_talks objectAtIndex:indexPath.row];
        persondetailcell.person_event_title_label.text = talk[@"name"];
    }
    else if (seg_index==1)
    {
        PFObject *poster = [person_posters objectAtIndex:indexPath.row];
        persondetailcell.person_event_title_label.text = poster[@"name"];
    }
    else
    {
        PFObject *abstract = [person_posters objectAtIndex:indexPath.row];
        persondetailcell.person_event_title_label.text = abstract[@"name"];
    }
    
    persondetailcell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([persondetailcell respondsToSelector:@selector(layoutMargins)]) {
        persondetailcell.layoutMargins = UIEdgeInsetsZero;
    }
    persondetailcell.person_event_title_label.textColor = [UIColor whiteColor];
    
    return persondetailcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"personeventsegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
