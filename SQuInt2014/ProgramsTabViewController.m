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

@interface ProgramsTabViewController ()

@end

@implementation ProgramsTabViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.posterview.hidden=YES;
    self.posterview.userInteractionEnabled=NO;
    
    if (![PFUser currentUser])
    {
        // Customize the Log In View Controller
        CustomLogInViewController *logInViewController = [[CustomLogInViewController alloc] init];
        [logInViewController setDelegate:self];
        [logInViewController setFacebookPermissions:[NSArray arrayWithObjects:@"user_friends", nil]];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *talkcell = [tableView dequeueReusableCellWithIdentifier:@"talkcell"];
    
    UITableViewCell *postercell = [tableView dequeueReusableCellWithIdentifier:@"postercell"];
    
    talkcell.selectionStyle = UITableViewCellSelectionStyleNone;
    postercell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (tableView.tag==1)
    {
        return talkcell;
    }
    else
    {
        return postercell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)segaction:(UISegmentedControl *)sender {
    /*
    switch (self.programseg.selectedSegmentIndex) {
        case 0:
            self.talkview.hidden=NO;
            self.posterview.hidden=YES;
            self.abstractview.hidden=YES;
            break;
        case 1:
            self.talkview.hidden=YES;
            self.posterview.hidden=NO;
            self.abstractview.hidden=YES;
            break;
        case 2:
            self.talkview.hidden=YES;
            self.posterview.hidden=YES;
            self.abstractview.hidden=NO;
            break;
        default:
            break;
    }
    */
    
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




@end
