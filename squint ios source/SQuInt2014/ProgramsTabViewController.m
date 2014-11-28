//
//  ProgramsTabViewController.m
//  SQuInt2014
//
//  Created by csjan on 4/17/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "ProgramsTabViewController.h"
#import "CustomLogInViewController.h"
#import "CustomSignUpViewController.h"
#import "PosterCellTableViewCell.h"
#import "TalkCellTableViewCell.h"
#import "AbstractCellTableViewCell.h"
#import "UIColor+ProjectColors.h"
#import "EventDetailViewController.h"
#import "AbstractPdfViewController.h"
#import "AppDelegate.h"

@interface ProgramsTabViewController ()

@end

int detail_type; //talk=0, poster=1, abstract=2
NSString *detail_objid;
int unread_total;

@implementation ProgramsTabViewController
@synthesize session_array;
@synthesize poster_array;
@synthesize session_and_talk;
@synthesize abstract_array;
@synthesize pullrefreshtalk;
@synthesize talk_only;

- (void)viewDidLoad
{
    [super viewDidLoad];

    //initialize elements
    self.session_array = [[NSMutableArray alloc] init];
    self.poster_array = [[NSMutableArray alloc] init];
    self.abstract_array = [[NSMutableArray alloc] init];
    self.session_and_talk = [[NSMutableDictionary alloc] init];
    self.talk_only = [[NSMutableArray alloc] init];
    self.talktable.tableFooterView = [[UIView alloc] init];
    self.postertable.tableFooterView = [[UIView alloc] init];
    self.abstracttable.tableFooterView = [[UIView alloc] init];
    
    //Pull To Refresh Controls
    //self.pullrefreshtalk = [[UIRefreshControl alloc] init];
    //[pullrefreshtalk addTarget:self action:@selector(refreshctrl:) forControlEvents:UIControlEventValueChanged];
    //[self.talktable addSubview:pullrefreshtalk];

    //styling
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.bottom_view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.talkview.backgroundColor = [UIColor clearColor];
    self.posterview.backgroundColor = [UIColor clearColor];
    self.abstractview.backgroundColor = [UIColor clearColor];
    self.talktable.backgroundColor = [UIColor clearColor];
    self.postertable.backgroundColor = [UIColor clearColor];
    self.abstracttable.backgroundColor = [UIColor clearColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self get_session_and_talk_data];
    [self get_poster_data];
    [self get_abstract_data];
    
    if (![PFUser currentUser])
    {
        // Customize the Log In View Controller
        CustomLogInViewController *logInViewController = [[CustomLogInViewController alloc] init];
        [logInViewController setDelegate:self];
        [logInViewController setFields: PFLogInFieldsDismissButton | PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton | PFLogInFieldsUsernameAndPassword ];
        
        // Create the sign up view controller
        CustomSignUpViewController *signUpViewController = [[CustomSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
        
    }
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self.programseg setSelectedSegmentIndex:0];
    
    [self check_selected_seg];
    //[self check_unread_count];
}

- (void) viewDidLayoutSubviews
{
    if ([self.talktable respondsToSelector:@selector(layoutMargins)]) {
        self.talktable.layoutMargins = UIEdgeInsetsZero;
        self.postertable.layoutMargins = UIEdgeInsetsZero;
        self.abstracttable.layoutMargins = UIEdgeInsetsZero;
    }
    [self check_selected_seg];
}

//called when pulling downward on the tableview
/*
- (void)refreshctrl:(id)sender
{
    //refresh code here
    [self.talktable reloadData];
    NSLog(@"session array count: %lu", self.session_array.count);
    PFObject *session_obj = [self.session_array objectAtIndex:0];
    NSMutableArray *talk_temparray = [self.session_and_talk objectForKey:session_obj.objectId];
    int talkcount =  [talk_temparray count];
    NSLog(@"talk count: %d", talkcount);
    // End Refreshing
    [(UIRefreshControl *)sender endRefreshing];
}
*/

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:@"Please fill in all fields."
                               delegate:nil
                      cancelButtonTitle:@"Done"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    
    // Associate the device with a user
    PFInstallation *installation = [PFInstallation currentInstallation];
    installation[@"user"] = [PFUser currentUser];
    [installation saveInBackground];
    NSLog(@"USER INSTALLATION ASSOCIATED");
    
    //turn on notifications (push)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:1 forKey:@"notifications"];
    [defaults synchronize];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"You can log in later from the settings tab"
                                                   delegate:self
                                          cancelButtonTitle:@"Done"
                                          otherButtonTitles:nil];
    [alert show];
    
}

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Please fill in all fields."
                                   delegate:nil
                          cancelButtonTitle:@"Done"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    
    // Associate the device with a user
    PFInstallation *installation = [PFInstallation currentInstallation];
    installation[@"user"] = [PFUser currentUser];
    [installation saveInBackground];
    NSLog(@"USER INSTALLATION ASSOCIATED");
    
    //turn on notifications (push)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:1 forKey:@"notifications"];
    [defaults synchronize];
    
    // Dismiss the PFSignUpViewController
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"sign up controller dismissed");
    }];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag==1)
    {
        //return self.session_array.count;
        //NSLog(@"talk_session count: %lu", (unsigned long)self.session_array.count);
        return 1;
    }
    else if (tableView.tag==2)
    {
        return 1;
    }
    else
    {
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==1)
    {
        //PFObject *session_obj = [self.session_array objectAtIndex:section];
        //NSMutableArray *talk_temparray = [self.session_and_talk objectForKey:session_obj.objectId];
        //return [talk_temparray count];
        //NSLog(@"talk count: %lu", [talk_temparray count]);
        return self.talk_only.count;
    }
    else if (tableView.tag==2)
    {
        return self.poster_array.count;
    }
    else
    {
        return self.abstract_array.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1)
    {
        //init cell and object
        TalkCellTableViewCell *talkcell = [tableView dequeueReusableCellWithIdentifier:@"talkcell"];
        //PFObject *session = [self.session_array objectAtIndex:indexPath.section];
        //NSMutableArray *talks = [self.session_and_talk objectForKey:session.objectId];
        //PFObject *talk = [talks objectAtIndex:indexPath.row];
        PFObject *talk = [self.talk_only objectAtIndex:indexPath.row];
        PFObject *author = talk[@"author"];
        PFObject *location = talk[@"location"];
        
        //fill data
        talkcell.talk_name_label.text = talk[@"name"];
        talkcell.talk_author_label.text = [NSString stringWithFormat:@"%@ %@", author[@"first_name"], author[@"last_name"]];
        talkcell.talk_description_label.text = talk[@"description"];
        talkcell.talk_location_label.text = location[@"name"];
        NSDate *date = talk[@"start_time"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat: @"MMM-d HH:mm"];
        NSString *dateString = [dateFormat stringFromDate:date];
        talkcell.talk_time_label.text = dateString;
        
        //styling
        if ([talkcell respondsToSelector:@selector(layoutMargins)])
        {
            talkcell.layoutMargins = UIEdgeInsetsZero;
        }
        talkcell.selectionStyle = UITableViewCellSelectionStyleNone;
        talkcell.backgroundColor = [UIColor clearColor];
        talkcell.talk_card_view.backgroundColor = [UIColor nu_deep_blue];
        talkcell.talk_card_view.alpha = 0.8;
        //talkcell.talk_detail_button.titleLabel.textColor = [UIColor bright_orange];
        [talkcell.talk_detail_button setTitleColor:[UIColor nu_bright_orange] forState:UIControlStateNormal];
        [talkcell.talk_detail_button setTitleColor:[UIColor nu_bright_orange] forState:UIControlStateHighlighted];
        talkcell.talk_trim_view.backgroundColor = [UIColor light_blue];
        talkcell.talk_location_label.textColor = [UIColor light_blue];
        talkcell.talk_time_label.textColor = [UIColor light_blue];
        talkcell.talk_card_view.layer.cornerRadius = 5;
        talkcell.talk_author_label.textColor = [UIColor light_blue];
        
        return talkcell;
    }
    else if (tableView.tag==2)
    {
        //init cell and object
        PosterCellTableViewCell *postercell = [tableView dequeueReusableCellWithIdentifier:@"postercell"];
        PFObject *poster = [self.poster_array objectAtIndex:indexPath.row];
        PFObject *author = poster[@"author"];
        PFObject *location = poster[@"location"];
        
        //fill data
        postercell.poster_topic_label.text = poster[@"name"];
        postercell.poster_author_label.text = [NSString stringWithFormat:@"%@ %@", author[@"first_name"], author[@"last_name"]];
        postercell.poster_content_label.text = poster[@"description"];
        postercell.poster_location_label.text = location[@"name"];
        
        //styling
        if ([postercell respondsToSelector:@selector(layoutMargins)])
        {
            postercell.layoutMargins = UIEdgeInsetsZero;
        }
        postercell.selectionStyle = UITableViewCellSelectionStyleNone;
        postercell.backgroundColor = [UIColor clearColor];
        postercell.poster_card_view.backgroundColor = [UIColor nu_deep_blue];
        postercell.poster_card_view.alpha = 0.8;
        //postercell.poster_detail_button.titleLabel.textColor = [UIColor bright_orange];
        [postercell.poster_detail_button setTitleColor:[UIColor nu_bright_orange] forState:UIControlStateNormal];
        [postercell.poster_detail_button setTitleColor:[UIColor nu_bright_orange] forState:UIControlStateHighlighted];
        postercell.poster_trim_view.backgroundColor = [UIColor light_blue];
        postercell.poster_location_label.textColor = [UIColor light_blue];
        postercell.poster_card_view.layer.cornerRadius = 5;
        postercell.poster_author_label.textColor = [UIColor light_blue];
        
        return postercell;
    }
    else
    {
        //init cell and object
        AbstractCellTableViewCell *abstractcell = [tableView dequeueReusableCellWithIdentifier:@"abstractcell"];
        PFObject *abstract = [self.abstract_array objectAtIndex:indexPath.row];
        PFObject *author = abstract[@"author"];
        
        //fill data
        abstractcell.abstract_title_label.text = abstract[@"name"];
        abstractcell.abstract_author_label.text = [NSString stringWithFormat:@"%@ %@", author[@"first_name"], author[@"last_name"]];
        
        //styling
        if ([abstractcell respondsToSelector:@selector(layoutMargins)])
        {
            abstractcell.layoutMargins = UIEdgeInsetsZero;
        }
        abstractcell.selectionStyle = UITableViewCellSelectionStyleNone;
        abstractcell.backgroundColor = [UIColor clearColor];
        abstractcell.abstract_card_view.backgroundColor = [UIColor nu_deep_blue];
        abstractcell.abstract_card_view.alpha = 0.8;
        //abstractcell.abstract_detail_button.titleLabel.textColor = [UIColor bright_orange];
        [abstractcell.abstract_detail_button setTitleColor:[UIColor nu_bright_orange] forState:UIControlStateNormal];
        [abstractcell.abstract_detail_button setTitleColor:[UIColor nu_bright_orange] forState:UIControlStateHighlighted];
        abstractcell.abstract_trim_view.backgroundColor = [UIColor light_blue];
        abstractcell.abstract_card_view.layer.cornerRadius = 5;
        
        return abstractcell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)segaction:(UISegmentedControl *)sender {
    
    if (self.programseg.selectedSegmentIndex==0)
    {
        //[self.talktable reloadData];
        [UIView animateWithDuration:0.5 animations:^{
            self.talkview.frame= CGRectMake(0, self.talkview.frame.origin.y, self.talkview.frame.size.width, self.talkview.frame.size.height);
            self.posterview.frame= CGRectMake(320, self.posterview.frame.origin.y, self.posterview.frame.size.width, self.posterview.frame.size.height);
            self.abstractview.frame= CGRectMake(320, self.abstractview.frame.origin.y, self.abstractview.frame.size.width, self.abstractview.frame.size.height);
        }];
        NSLog(@"switch to talk seg");
    }
    else if (self.programseg.selectedSegmentIndex==1)
    {
        //[self.postertable reloadData];
        [UIView animateWithDuration:0.5 animations:^{
            self.talkview.frame= CGRectMake(-320, self.talkview.frame.origin.y, self.talkview.frame.size.width, self.talkview.frame.size.height);
            self.posterview.frame= CGRectMake(0, self.posterview.frame.origin.y, self.posterview.frame.size.width, self.posterview.frame.size.height);
            self.abstractview.frame= CGRectMake(320, self.abstractview.frame.origin.y, self.abstractview.frame.size.width, self.abstractview.frame.size.height);
        }];
        NSLog(@"switch to poster seg");
    }
    else if (self.programseg.selectedSegmentIndex==2)
    {
        //[self.abstracttable reloadData];
        [UIView animateWithDuration:0.5 animations:^{
            self.talkview.frame= CGRectMake(-320, self.talkview.frame.origin.y, self.talkview.frame.size.width, self.talkview.frame.size.height);
            self.posterview.frame= CGRectMake(-320, self.posterview.frame.origin.y, self.posterview.frame.size.width, self.posterview.frame.size.height);
            self.abstractview.frame= CGRectMake(0, self.abstractview.frame.origin.y, self.abstractview.frame.size.width, self.abstractview.frame.size.height);
        }];
        NSLog(@"switch to abstract seg");
    }
}

- (void) get_session_and_talk_data
{
    /*
    PFQuery *sessionquery = [PFQuery queryWithClassName:@"session"];
    [sessionquery orderByDescending:@"start_time"];
    [sessionquery includeKey:@"location"];
    [sessionquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"sessionquery success");
        self.session_array = [objects mutableCopy];
        for (PFObject *session_pfobj in objects)
        {
            PFQuery *talk_subquery = [PFQuery queryWithClassName:@"talk"];
            [talk_subquery whereKey:@"session" equalTo:session_pfobj];
            [talk_subquery includeKey:@"location"];
            [talk_subquery includeKey:@"abstract"];
            [talk_subquery includeKey:@"author"];
            [talk_subquery findObjectsInBackgroundWithBlock:^(NSArray *objectss, NSError *error) {
                NSLog(@"talk sub query success with count: %lu", (unsigned long)[objectss count]);
                [self.session_and_talk setObject:[objectss mutableCopy] forKey:session_pfobj.objectId];
            }];
        }
    }];
    */
    
    PFQuery *talk_subquery = [PFQuery queryWithClassName:@"talk"];
    [talk_subquery includeKey:@"location"];
    [talk_subquery includeKey:@"abstract"];
    [talk_subquery includeKey:@"author"];
    [talk_subquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"talk query success with count: %lu", (unsigned long)[objects count]);
        self.talk_only = [objects mutableCopy];
        [self.talktable reloadData];
    }];
}

- (void) get_poster_data
{
    PFQuery *posterquery = [PFQuery queryWithClassName:@"poster"];
    [posterquery orderByDescending:@"name"];
    [posterquery includeKey:@"author"];
    [posterquery includeKey:@"abstract"];
    [posterquery includeKey:@"location"];
    [posterquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"poster query success");
        for (PFObject *poster_obj in objects)
        {
            [self.poster_array addObject:poster_obj];
        }
        [self.postertable reloadData];
    }];
}

- (void) get_abstract_data
{
    PFQuery *abstractquery = [PFQuery queryWithClassName:@"abstract"];
    [abstractquery orderByDescending:@"name"];
    [abstractquery includeKey:@"author"];
    [abstractquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"abstract query success");
        for (PFObject *abstract_obj in objects)
        {
            [self.abstract_array addObject:abstract_obj];
        }
        [self.abstracttable reloadData];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if (detail_type==0)
    {
        EventDetailViewController *controller = [segue destinationViewController];
        controller.event_type = 0;
        controller.event_objid = detail_objid;
    }
    else if (detail_type==1)
    {
        EventDetailViewController *controller = [segue destinationViewController];
        controller.event_type = 1;
        controller.event_objid = detail_objid;
    }
    else if (detail_type==2)
    {
        AbstractPdfViewController *controller = (AbstractPdfViewController *)[segue destinationViewController];
        controller.from_author = 0;
        controller.abstract_objid = detail_objid;
    }
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Program" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [backButton setTitleTextAttributes:[[NSDictionary alloc] initWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0] , NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.backBarButtonItem = backButton;

}

- (IBAction)poster_detail_tap:(UIButton *)sender {
    PosterCellTableViewCell *cell = (PosterCellTableViewCell *)[[[sender superview] superview] superview];
    NSIndexPath *tapped_path = [self.postertable indexPathForCell:cell];
    NSLog(@"poster_detail_tap: %ld", (long)tapped_path.row);
    
    PFObject *poster = [self.poster_array objectAtIndex:tapped_path.row];
    detail_objid = poster.objectId;
    detail_type = 1;
    
    [self performSegueWithIdentifier:@"programeventsegue" sender:self];
}

- (IBAction)abstract_detail_tap:(UIButton *)sender {
    AbstractCellTableViewCell *cell = (AbstractCellTableViewCell *)[[[sender superview] superview] superview];
    NSIndexPath *tapped_path = [self.abstracttable indexPathForCell:cell];
    NSLog(@"abstract_detail_tap: %ld", (long)tapped_path.row);
    PFObject *abstract = [self.abstract_array objectAtIndex:tapped_path.row];
    detail_objid = abstract.objectId;
    detail_type = 2;
    
    [self performSegueWithIdentifier:@"programabstractsegue" sender:self];
}

- (IBAction)talk_detail_tap:(UIButton *)sender {
    TalkCellTableViewCell *cell = (TalkCellTableViewCell *)[[[sender superview] superview] superview];
    NSIndexPath *tapped_path = [self.talktable indexPathForCell:cell];
    //NSLog(@"poster_detail_tap: %ld, %ld", (long)tapped_path.section, (long)tapped_path.row);
    
    //PFObject *session = [self.session_array objectAtIndex:tapped_path.section];
    //NSMutableArray *talks = [self.session_and_talk objectForKey:session.objectId];
    //PFObject *talk = [talks objectAtIndex:tapped_path.row];
    PFObject *talk = [self.talk_only objectAtIndex:tapped_path.row];
    detail_objid = talk.objectId;
    detail_type = 0;
    
    [self performSegueWithIdentifier:@"programeventsegue" sender:self];
}

- (void) check_unread_count
{
    unread_total = 0;
    if ([PFUser currentUser])
    {
        PFUser *currentuser = [PFUser currentUser];

        PFQuery *query = [PFQuery queryWithClassName:@"conversation"];
        [query orderByDescending:@"createdAt"];
        [query includeKey:@"user_a"];
        [query includeKey:@"user_b"];
        [query includeKey:@"user_a_unread"];
        [query includeKey:@"user_b_unread"];
        [query whereKey:@"user_a" equalTo:currentuser];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            NSLog(@"conversation query one success with count: %lu", (unsigned long)[objects count]);
            for (PFObject *object in objects)
            {
                NSNumber *unreadanum = object[@"user_a_unread"];
                unread_total += [unreadanum intValue];
                UITabBarItem *tbItem = (UITabBarItem *)[[self tabBarController].tabBar.items objectAtIndex:1];
                if (unread_total>0) {
                    //tbItem.badgeValue = [NSString stringWithFormat:@"%i", unread_total];
                }
                else
                {
                    //tbItem.badgeValue = nil;
                }
                
            }
        }];
        
        PFQuery *query_two = [PFQuery queryWithClassName:@"conversation"];
        [query_two orderByDescending:@"createdAt"];
        [query_two includeKey:@"user_a"];
        [query_two includeKey:@"user_b"];
        [query_two whereKey:@"user_b" equalTo:currentuser];
        [query_two findObjectsInBackgroundWithBlock:^(NSArray *objectss, NSError *error) {
            NSLog(@"conversation query two success with count: %lu", (unsigned long)[objectss count]);
            for (PFObject *object in objectss)
            {
                NSNumber *unreadanum = object[@"user_b_unread"];
                unread_total += [unreadanum intValue];
                UITabBarItem *tbItem = (UITabBarItem *)[[self tabBarController].tabBar.items objectAtIndex:1];
                if (unread_total>0) {
                    //tbItem.badgeValue = [NSString stringWithFormat:@"%i", unread_total];
                }
                else
                {
                    //tbItem.badgeValue = nil;
                }
            }
        }];
        
        
    }
    
}

- (void) check_selected_seg
{
    int sel_index = self.programseg.selectedSegmentIndex;
    if (sel_index==0)
    {
        //talk seg selected
        self.talkview.frame= CGRectMake(0, self.talkview.frame.origin.y, self.talkview.frame.size.width, self.talkview.frame.size.height);
        self.posterview.frame= CGRectMake(320, self.posterview.frame.origin.y, self.posterview.frame.size.width, self.posterview.frame.size.height);
        self.abstractview.frame= CGRectMake(320, self.abstractview.frame.origin.y, self.abstractview.frame.size.width, self.abstractview.frame.size.height);


        NSLog(@"CHECK SEG: TALK");
    }
    else if (sel_index==1)
    {
        //poster seg selected
        self.talkview.frame= CGRectMake(-320, self.talkview.frame.origin.y, self.talkview.frame.size.width, self.talkview.frame.size.height);
        self.posterview.frame= CGRectMake(0, self.posterview.frame.origin.y, self.posterview.frame.size.width, self.posterview.frame.size.height);
        self.abstractview.frame= CGRectMake(320, self.abstractview.frame.origin.y, self.abstractview.frame.size.width, self.abstractview.frame.size.height);


        NSLog(@"CHECK SEG: POSTER");
    }
    else if (sel_index==2)
    {
        //abstract seg selected
        self.talkview.frame= CGRectMake(-320, self.talkview.frame.origin.y, self.talkview.frame.size.width, self.talkview.frame.size.height);
        self.posterview.frame= CGRectMake(-320, self.posterview.frame.origin.y, self.posterview.frame.size.width, self.posterview.frame.size.height);
        self.abstractview.frame= CGRectMake(0, self.abstractview.frame.origin.y, self.abstractview.frame.size.width, self.abstractview.frame.size.height);

        NSLog(@"CHECK SEG: ABSTRACT");
        NSLog(@"COORD:%f", self.talkview.frame.origin.x);
    }
}



@end
