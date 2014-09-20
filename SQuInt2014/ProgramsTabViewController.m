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

@interface ProgramsTabViewController ()

@end

@implementation ProgramsTabViewController
@synthesize session_array;
@synthesize poster_array;
@synthesize session_and_talk;
@synthesize abstract_array;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //initialize elements
    self.session_array = [[NSMutableArray alloc] init];
    self.poster_array = [[NSMutableArray alloc] init];
    self.abstract_array = [[NSMutableArray alloc] init];
    self.session_and_talk = [[NSMutableDictionary alloc] init];
    
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
        NSMutableArray *talk_temparray = [self.session_and_talk objectForKey:session_obj];
        return [talk_temparray count];
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
        TalkCellTableViewCell *talkcell = [tableView dequeueReusableCellWithIdentifier:@"talkcell"];
        PFObject *session = [self.session_array objectAtIndex:indexPath.section];
        NSMutableArray *talks = [self.session_and_talk objectForKey:session];
        PFObject *talk = [talks objectAtIndex:indexPath.row];
        talkcell.talk_name_label.text = talk[@"name"];
        return talkcell;
    }
    else if (tableView.tag==2)
    {
        PosterCellTableViewCell *postercell = [tableView dequeueReusableCellWithIdentifier:@"postercell"];
        PFObject *poster = [self.poster_array objectAtIndex:indexPath.row];
        postercell.poster_topic_label.text = poster[@"name"];
        return postercell;
    }
    else
    {
        AbstractCellTableViewCell *abstractcell = [tableView dequeueReusableCellWithIdentifier:@"abstractcell"];
        PFObject *abstract = [self.abstract_array objectAtIndex:indexPath.row];
        abstractcell.abstract_title_label.text = abstract[@"name"];
        return abstractcell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)segaction:(UISegmentedControl *)sender {
    
    if (self.programseg.selectedSegmentIndex==0)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.talkview.frame= CGRectMake(0, self.talkview.frame.origin.y, self.talkview.frame.size.width, self.talkview.frame.size.height);
            self.posterview.frame= CGRectMake(320, self.posterview.frame.origin.y, self.posterview.frame.size.width, self.posterview.frame.size.height);
            self.abstractview.frame= CGRectMake(320, self.abstractview.frame.origin.y, self.abstractview.frame.size.width, self.abstractview.frame.size.height);
        }];
    }
    else if (self.programseg.selectedSegmentIndex==1)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.talkview.frame= CGRectMake(-320, self.talkview.frame.origin.y, self.talkview.frame.size.width, self.talkview.frame.size.height);
            self.posterview.frame= CGRectMake(0, self.posterview.frame.origin.y, self.posterview.frame.size.width, self.posterview.frame.size.height);
            self.abstractview.frame= CGRectMake(320, self.abstractview.frame.origin.y, self.abstractview.frame.size.width, self.abstractview.frame.size.height);
        }];
    }
    else if (self.programseg.selectedSegmentIndex==2)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.talkview.frame= CGRectMake(-320, self.talkview.frame.origin.y, self.talkview.frame.size.width, self.talkview.frame.size.height);
            self.posterview.frame= CGRectMake(-320, self.posterview.frame.origin.y, self.posterview.frame.size.width, self.posterview.frame.size.height);
            self.abstractview.frame= CGRectMake(0, self.abstractview.frame.origin.y, self.abstractview.frame.size.width, self.abstractview.frame.size.height);
        }];
    }
}

- (void) get_session_and_talk_data
{
    PFQuery *sessionquery = [PFQuery queryWithClassName:@"session"];
    [sessionquery orderByDescending:@"start_time"];
    [sessionquery includeKey:@"location"];
    [sessionquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"sessionquery success");
        for (PFObject *session_pfobj in objects)
        {
            NSMutableArray *temp_talkarray = [[NSMutableArray alloc] init];
            PFQuery *talk_subquery = [PFQuery queryWithClassName:@"talk"];
            [talk_subquery whereKey:@"session" equalTo:session_pfobj];
            [talk_subquery includeKey:@"location"];
            [talk_subquery includeKey:@"abstract"];
            [talk_subquery includeKey:@"author"];
            [talk_subquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                NSLog(@"talk sub query success");
                for (PFObject *talk_pfobj in objects)
                {
                    [temp_talkarray addObject:talk_pfobj];
                }
                [self.talktable reloadData];
            }];
            [self.session_and_talk setObject:temp_talkarray forKey:session_pfobj];
            [self.session_array addObject:session_pfobj];
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
