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

@interface ProgramsTabViewController ()

@end

@implementation ProgramsTabViewController
@synthesize session_array;
@synthesize poster_array;
@synthesize session_and_talk;
@synthesize abstract_array;
@synthesize pullrefreshtalk;

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    //initialize elements
    self.session_array = [[NSMutableArray alloc] init];
    self.poster_array = [[NSMutableArray alloc] init];
    self.abstract_array = [[NSMutableArray alloc] init];
    self.session_and_talk = [[NSMutableDictionary alloc] init];
    
    self.talktable.tableFooterView = [[UIView alloc] init];
    self.postertable.tableFooterView = [[UIView alloc] init];
    self.abstracttable.tableFooterView = [[UIView alloc] init];
    
    //Pull To Refresh Controls
    self.pullrefreshtalk = [[UIRefreshControl alloc] init];
    [pullrefreshtalk addTarget:self action:@selector(refreshctrl:) forControlEvents:UIControlEventValueChanged];
    [self.talktable addSubview:pullrefreshtalk];

    
    self.bottom_view.backgroundColor = [UIColor reallylight_blue];
    //self.talkview.backgroundColor = [UIColor shade_blue];
    //self.posterview.backgroundColor = [UIColor shade_blue];
    //self.abstractview.backgroundColor = [UIColor shade_blue];
    self.talktable.backgroundColor = [UIColor reallylight_blue];
    self.postertable.backgroundColor = [UIColor reallylight_blue];
    self.abstracttable.backgroundColor = [UIColor reallylight_blue];
    
    
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

- (void) viewDidLayoutSubviews
{
    if ([self.talktable respondsToSelector:@selector(layoutMargins)]) {
        self.talktable.layoutMargins = UIEdgeInsetsZero;
        self.postertable.layoutMargins = UIEdgeInsetsZero;
        self.abstracttable.layoutMargins = UIEdgeInsetsZero;
    }
}

//called when pulling downward on the tableview
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
        return self.session_array.count;
        NSLog(@"talk_session count: %lu", (unsigned long)self.session_array.count);
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
        PFObject *session_obj = [self.session_array objectAtIndex:section];
        NSMutableArray *talk_temparray = [self.session_and_talk objectForKey:session_obj.objectId];
        return [talk_temparray count];
        NSLog(@"talk count: %lu", [talk_temparray count]);
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
        PFObject *session = [self.session_array objectAtIndex:indexPath.section];
        NSMutableArray *talks = [self.session_and_talk objectForKey:session.objectId];
        PFObject *talk = [talks objectAtIndex:indexPath.row];
        PFObject *author = talk[@"author"];
        PFObject *location = talk[@"location"];
        
        //fill data
        talkcell.talk_name_label.text = talk[@"name"];
        talkcell.talk_author_label.text = [NSString stringWithFormat:@"%@ %@", author[@"first_name"], author[@"last_name"]];
        talkcell.talk_description_label.text = talk[@"description"];
        talkcell.talk_location_label.text = location[@"name"];
        NSDate *date = talk[@"start_time"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat: @"MM/dd HH:mm"];
        NSString *dateString = [dateFormat stringFromDate:date];
        talkcell.talk_time_label.text = dateString;
        
        //styling
        if ([talkcell respondsToSelector:@selector(layoutMargins)])
        {
            talkcell.layoutMargins = UIEdgeInsetsZero;
        }
        talkcell.selectionStyle = UITableViewCellSelectionStyleNone;
        talkcell.backgroundColor = [UIColor clearColor];
        talkcell.talk_card_view.backgroundColor = [UIColor main_blue];
        talkcell.talk_detail_button.titleLabel.textColor = [UIColor bright_orange];
        talkcell.talk_trim_view.backgroundColor = [UIColor main_orange];
        talkcell.talk_location_label.textColor = [UIColor light_blue];
        talkcell.talk_time_label.textColor = [UIColor light_blue];
        talkcell.talk_card_view.layer.cornerRadius = 5;
        
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
        postercell.poster_card_view.backgroundColor = [UIColor main_blue];
        postercell.poster_detail_button.titleLabel.textColor = [UIColor bright_orange];
        postercell.poster_trim_view.backgroundColor = [UIColor main_orange];
        postercell.poster_location_label.textColor = [UIColor light_blue];
        postercell.poster_card_view.layer.cornerRadius = 5;
        
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
        abstractcell.abstract_card_view.backgroundColor = [UIColor main_blue];
        abstractcell.abstract_detail_button.titleLabel.textColor = [UIColor bright_orange];
        abstractcell.abstract_trim_view.backgroundColor = [UIColor main_orange];
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
        [self.talktable reloadData];
        [UIView animateWithDuration:0.5 animations:^{
            self.talkview.frame= CGRectMake(0, self.talkview.frame.origin.y, self.talkview.frame.size.width, self.talkview.frame.size.height);
            self.posterview.frame= CGRectMake(320, self.posterview.frame.origin.y, self.posterview.frame.size.width, self.posterview.frame.size.height);
            self.abstractview.frame= CGRectMake(320, self.abstractview.frame.origin.y, self.abstractview.frame.size.width, self.abstractview.frame.size.height);
        }];
        NSLog(@"switch to talk seg");
    }
    else if (self.programseg.selectedSegmentIndex==1)
    {
        [self.postertable reloadData];
        [UIView animateWithDuration:0.5 animations:^{
            self.talkview.frame= CGRectMake(-320, self.talkview.frame.origin.y, self.talkview.frame.size.width, self.talkview.frame.size.height);
            self.posterview.frame= CGRectMake(0, self.posterview.frame.origin.y, self.posterview.frame.size.width, self.posterview.frame.size.height);
            self.abstractview.frame= CGRectMake(320, self.abstractview.frame.origin.y, self.abstractview.frame.size.width, self.abstractview.frame.size.height);
        }];
        NSLog(@"switch to poster seg");
    }
    else if (self.programseg.selectedSegmentIndex==2)
    {
        [self.abstracttable reloadData];
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
}



- (IBAction)poster_detail_tap:(UIButton *)sender {
    PosterCellTableViewCell *cell = (PosterCellTableViewCell *)[[[sender superview] superview] superview];
    NSIndexPath *tapped_path = [self.postertable indexPathForCell:cell];
    NSLog(@"poster_detail_tap: %ld", (long)tapped_path.row);
}
- (IBAction)abstract_detail_tap:(UIButton *)sender {
    AbstractCellTableViewCell *cell = (AbstractCellTableViewCell *)[[[sender superview] superview] superview];
    NSIndexPath *tapped_path = [self.abstracttable indexPathForCell:cell];
    NSLog(@"abstract_detail_tap: %ld", (long)tapped_path.row);
}

- (IBAction)talk_detail_tap:(UIButton *)sender {
    TalkCellTableViewCell *cell = (TalkCellTableViewCell *)[[[sender superview] superview] superview];
    NSIndexPath *tapped_path = [self.talktable indexPathForCell:cell];
    NSLog(@"poster_detail_tap: %ld, %ld", (long)tapped_path.section, (long)tapped_path.row);
}
@end
