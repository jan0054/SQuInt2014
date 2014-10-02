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
#import "EventDetailViewController.h"
#import "AbstractPdfViewController.h"

@interface PersonDetailViewController ()

@end

PFObject *the_person;
NSMutableArray *person_talks;
NSMutableArray *person_posters;
NSMutableArray *person_abstracts;
int seg_index;
BOOL mail_enabled;
BOOL web_enabled;
BOOL chat_enabled;
NSString *chosen_event_id;

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.person_card_view.backgroundColor = [UIColor nu_deep_blue];
    self.person_card_view.alpha = 0.8;
    self.person_trim_view.backgroundColor = [UIColor light_blue];
    //self.person_detail_table.backgroundColor = [UIColor main_blue];
    self.person_detail_seg.tintColor = [UIColor whiteColor];
    self.person_card_view.layer.cornerRadius = 5;
    [self.person_chat_button setTitleColor:[UIColor nu_bright_orange] forState:UIControlStateNormal];
    [self.person_chat_button setTitleColor:[UIColor nu_bright_orange] forState:UIControlStateHighlighted];
    [self.person_email_button setTitleColor:[UIColor nu_bright_orange] forState:UIControlStateNormal];
    [self.person_email_button setTitleColor:[UIColor nu_bright_orange] forState:UIControlStateHighlighted];
    [self.person_link_button setTitleColor:[UIColor nu_bright_orange] forState:UIControlStateNormal];
    [self.person_link_button setTitleColor:[UIColor nu_bright_orange] forState:UIControlStateHighlighted];
    
    [self get_person_data];
    
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
    if (mail_enabled==YES)
    {
        NSString *mailstr = the_person[@"email"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailstr]];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"This person does not have a public email"
                                                       delegate:self
                                              cancelButtonTitle:@"Done"
                                              otherButtonTitles:nil];
        [alert show];

    }
}

- (IBAction)person_link_button_tap:(UIButton *)sender {
    if (web_enabled == YES)
    {
        NSString *linkstr = the_person[@"link"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkstr]];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"This person does not have a public webpage"
                                                       delegate:self
                                              cancelButtonTitle:@"Done"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void) get_person_data
{
    PFQuery *personquery = [PFQuery queryWithClassName:@"person"];
    [personquery includeKey:@"user"];
    [personquery getObjectInBackgroundWithId:self.person_objid block:^(PFObject *object, NSError *error) {
        NSLog(@"detail person query success");
        the_person = object;
        self.person_name_label.text = [NSString stringWithFormat:@"%@, %@", the_person[@"last_name"], the_person[@"first_name"]];
        self.person_institution_label.text = the_person[@"institution"];
        [self get_person_talks];
        [self get_person_posters];
        [self get_person_abstracts];
        NSString *mailstr = the_person[@"email"];
        NSString *linkstr = the_person[@"link"];
        if (mailstr == (id)[NSNull null] || mailstr.length == 0 )
        {
            [self.person_email_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.person_email_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
            [self.person_email_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            mail_enabled = NO;
            NSLog(@"mail button disabled");
        }
        else
        {
            mail_enabled = YES;
        }
        if ( linkstr == (id)[NSNull null] ||linkstr.length == 0 )
        {
            [self.person_link_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.person_link_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
            [self.person_link_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            web_enabled = NO;
            NSLog(@"web button disabled");
        }
        else
        {
            web_enabled = YES;
        }
        NSNumber *chat = the_person[@"is_user"];
        int chatint = [chat intValue];
        if ( chatint == 0)
        {
            [self.person_chat_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.person_chat_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
            [self.person_chat_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            chat_enabled = NO;
            NSLog(@"chat button disabled");
        }
        else
        {
            chat_enabled = YES;
        }
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
            [self.person_detail_table reloadData];
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
            [self.person_detail_table reloadData];
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
            [self.person_detail_table reloadData];
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
        PFObject *abstract = [person_abstracts objectAtIndex:indexPath.row];
        persondetailcell.person_event_title_label.text = abstract[@"name"];
    }
    
    persondetailcell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([persondetailcell respondsToSelector:@selector(layoutMargins)]) {
        persondetailcell.layoutMargins = UIEdgeInsetsZero;
    }
    persondetailcell.person_event_title_label.textColor = [UIColor whiteColor];
    persondetailcell.backgroundColor = [UIColor clearColor];
    return persondetailcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (seg_index==0)
    {
        PFObject *talk = [person_talks objectAtIndex:indexPath.row];
        chosen_event_id = talk.objectId;
        [self performSegueWithIdentifier:@"authoreventsegue" sender:self];
    }
    else if (seg_index==1)
    {
        PFObject *poster = [person_posters objectAtIndex:indexPath.row];
        chosen_event_id = poster.objectId;
        [self performSegueWithIdentifier:@"authoreventsegue" sender:self];
    }
    else if (seg_index==2)
    {
        PFObject *abstract = [person_abstracts objectAtIndex:indexPath.row];
        chosen_event_id = abstract.objectId;
        [self performSegueWithIdentifier:@"authorabstractsegue" sender:self];
    }

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (seg_index == 0)
    {
        EventDetailViewController *controller = (EventDetailViewController *)[segue destinationViewController];
        controller.from_author = 1;
        controller.event_objid = chosen_event_id;
        controller.event_type = 0;
    }
    else if (seg_index==1)
    {
        EventDetailViewController *controller = (EventDetailViewController *)[segue destinationViewController];
        controller.from_author = 1;
        controller.event_objid = chosen_event_id;
        controller.event_type = 1;
    }
    else if (seg_index==2)
    {
        AbstractPdfViewController *controller = (AbstractPdfViewController *)[segue destinationViewController];
        controller.from_author = 1;
        controller.abstract_objid = chosen_event_id;
    }
}


- (IBAction)person_chat_button_tap:(UIButton *)sender {
    if (chat_enabled == YES)
    {
        NSLog(@"going to chat interface");
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"This person is not signed in or has turned off chat"
                                                       delegate:self
                                              cancelButtonTitle:@"Done"
                                              otherButtonTitles:nil];
        [alert show];
    }

}


@end
