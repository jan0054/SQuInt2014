//
//  FeedbackTabViewController.m
//  SQuInt2014
//
//  Created by csjan on 4/17/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "FeedbackTabViewController.h"
#import "UIColor+ProjectColors.h"
@interface FeedbackTabViewController ()

@end


@implementation FeedbackTabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.settingstable.backgroundColor = [UIColor main_blue];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.settingstable.tableFooterView = [[UIView alloc] init];

}

- (void) viewDidLayoutSubviews
{
    if ([self.settingstable respondsToSelector:@selector(layoutMargins)]) {
        self.settingstable.layoutMargins = UIEdgeInsetsZero;
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.settingstable reloadData];
}

-(void) log_out
{
    [PFUser logOut];
}

-(void) log_in
{
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
    [self.settingstable reloadData];
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
    [self.settingstable reloadData];
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
    SettingLoginCellTableViewCell *logincell = [tableView dequeueReusableCellWithIdentifier:@"logincell"];
    SettingPushCellTableViewCell *pushcell = [tableView dequeueReusableCellWithIdentifier:@"pushcell"];
    GeneralSettingCellTableViewCell *generalsettingcell = [tableView dequeueReusableCellWithIdentifier:@"generalsettingcell"];
    
    if (indexPath.row==0)
    {
        [logincell.login_action_button setTitle:@"Log In" forState:UIControlStateNormal];
        [logincell.login_action_button setTitle:@"Log In" forState:UIControlStateHighlighted];
        NSString *name = @"Log in to message other users";
        
        if ([PFUser currentUser])
        {
            PFUser *cur = [PFUser currentUser];
            name = [NSString stringWithFormat:@"Logged in as %@", cur.username];
            
            [logincell.login_action_button setTitle:@"Log Out" forState:UIControlStateNormal];
            [logincell.login_action_button setTitle:@"Log Out" forState:UIControlStateHighlighted];
        }
        logincell.login_action_button.titleLabel.textColor = [UIColor bright_orange];
        logincell.login_name_label.text = name;
        logincell.selectionStyle = UITableViewCellSelectionStyleNone;
        logincell.backgroundColor = [UIColor clearColor];
        logincell.login_name_label.textColor = [UIColor whiteColor];
        if ([logincell respondsToSelector:@selector(layoutMargins)]) {
            logincell.layoutMargins = UIEdgeInsetsZero;
        }
        return logincell;
    }
    else if (indexPath.row==1)
    {
        pushcell.push_status_label.text = @"Notifications are ON";
        pushcell.push_status_label.textColor = [UIColor whiteColor];
        pushcell.selectionStyle = UITableViewCellSelectionStyleNone;
        pushcell.backgroundColor = [UIColor clearColor];
        if ([pushcell respondsToSelector:@selector(layoutMargins)]) {
            pushcell.layoutMargins = UIEdgeInsetsZero;
        }
        return pushcell;
    }
    else if (indexPath.row==2)
    {
        generalsettingcell.general_name_label.text = @"About Us";
        generalsettingcell.general_name_label.textColor = [UIColor whiteColor];
        generalsettingcell.backgroundColor = [UIColor clearColor];
        if ([generalsettingcell respondsToSelector:@selector(layoutMargins)]) {
            generalsettingcell.layoutMargins = UIEdgeInsetsZero;
        }
        return generalsettingcell;
    }
    else if (indexPath.row==3)
    {
        generalsettingcell.general_name_label.text = @"Feedback";
        generalsettingcell.general_name_label.textColor = [UIColor whiteColor];
        generalsettingcell.backgroundColor = [UIColor clearColor];
        if ([generalsettingcell respondsToSelector:@selector(layoutMargins)]) {
            generalsettingcell.layoutMargins = UIEdgeInsetsZero;
        }
        return generalsettingcell;
    }
    else
    {
        generalsettingcell.general_name_label.text = @"Privacy Notice and Terms of Service";
        generalsettingcell.general_name_label.textColor = [UIColor whiteColor];
        generalsettingcell.backgroundColor = [UIColor clearColor];
        if ([generalsettingcell respondsToSelector:@selector(layoutMargins)]) {
            generalsettingcell.layoutMargins = UIEdgeInsetsZero;
        }
        return generalsettingcell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2)
    {
        [self performSegueWithIdentifier:@"aboutsegue" sender:self];
    }
    else if (indexPath.row ==3)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://jan0054@gmail.com"]];
    }
    else if (indexPath.row==4)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://tapgo.cc/tw/?page_id=1060"]];
    }
}


- (IBAction)login_button_tap:(UIButton *)sender {
    if (![PFUser currentUser])
    {
        [self log_in];
    }
    else
    {
        [self log_out];
        [self.settingstable reloadData];
    }
}





@end
