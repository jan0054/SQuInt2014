//
//  CustomLogInViewController.m
//  SQuInt2014
//
//  Created by csjan on 9/1/14.
//  Copyright (c) 2014 tapgo. All rights reserved.
//

#import "CustomLogInViewController.h"
#import "UIColor+ProjectColors.h"

@interface CustomLogInViewController ()

@end

@implementation CustomLogInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor main_blue];
    
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inapp_logo"]]];
    
    [self.logInView.dismissButton setImage:[UIImage imageNamed:@"cancelwhite.png"] forState:UIControlStateNormal];
    [self.logInView.dismissButton setImage:[UIImage imageNamed:@"cancelwhite.png"] forState:UIControlStateHighlighted];
    
    //self.logInView.signUpLabel.text = @"新用戶請註冊帳號";
    //self.logInView.externalLogInLabel.text = @"使用Facebook帳號登入";
    
    //[self.logInView.facebookButton setBackgroundColor:[UIColor colorWithRed:0.23 green:0.35 blue:0.59 alpha:1]];
    //[self.logInView.facebookButton setBackgroundImage:nil forState:UIControlStateNormal];
    //[self.logInView.facebookButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    
    [self.logInView.signUpButton setBackgroundColor:[UIColor shade_blue]];
    [self.logInView.signUpButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.logInView.signUpButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    //[self.logInView.signUpButton setTitle:@"註冊" forState:UIControlStateNormal];
    //[self.logInView.signUpButton setTitle:@"註冊" forState:UIControlStateHighlighted];
    [self.logInView.signUpButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0]];
    
    [self.logInView.logInButton setBackgroundColor:[UIColor dark_blue]];
    [self.logInView.logInButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.logInView.logInButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    [self.logInView.logInButton setImage:nil forState:UIControlStateNormal];
    [self.logInView.logInButton setImage:nil forState:UIControlStateHighlighted];
    [self.logInView.logInButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0]];
    
     [self.logInView.signUpLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0]];
     
    //[self.logInView.passwordForgottenButton setBackgroundImage:[UIImage imageNamed:@"noreply.png"] forState:UIControlStateNormal];
    //[self.logInView.passwordForgottenButton setBackgroundImage:[UIImage imageNamed:@"noreply.png"] forState:UIControlStateHighlighted];
    //[self.logInView.passwordForgottenButton setBackgroundColor:[UIColor clearColor]];
    
    // Remove text shadow
    CALayer *layer = self.logInView.usernameField.layer;
    layer.shadowOpacity = 0.0;
    layer = self.logInView.passwordField.layer;
    layer.shadowOpacity = 0.0;
    layer = self.logInView.signUpButton.layer;
    layer.shadowOpacity = 0.0;
    self.logInView.signUpLabel.shadowColor=[UIColor clearColor];
    self.logInView.signUpButton.titleLabel.shadowColor = [UIColor clearColor];
    self.logInView.signUpButton.layer.shadowOpacity=0.0;
    self.logInView.externalLogInLabel.shadowColor=[UIColor clearColor];
    
    // Set field text color
    [self.logInView.usernameField setBackgroundColor:[UIColor whiteColor]];
    [self.logInView.passwordField setBackgroundColor:[UIColor whiteColor]];
    //self.logInView.usernameField.placeholder=@"帳號";
    //self.logInView.passwordField.placeholder=@"密碼";
    [self.logInView.usernameField setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0]];
    [self.logInView.passwordField setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Set frame for elements
    //[self.logInView.dismissButton setFrame:CGRectMake(290.0f, 52.0f, 24.0f, 24.0f)];
    //[self.logInView.logo setFrame:CGRectMake(140, 70, 40, 40)];
    //[self.logInView.passwordForgottenButton setFrame:CGRectMake(288, 263, 24, 24)];
    //[self.logInView.facebookButton setFrame:CGRectMake(35.0f, 287.0f, 120.0f, 40.0f)];
    //[self.logInView.twitterButton setFrame:CGRectMake(35.0f+130.0f, 287.0f, 120.0f, 40.0f)];
    //[self.logInView.signUpButton setFrame:CGRectMake(35.0f, 385.0f, 250.0f, 40.0f)];
    //[self.logInView.usernameField setFrame:CGRectMake(35.0f, 145.0f, 250.0f, 50.0f)];
    //[self.logInView.passwordField setFrame:CGRectMake(35.0f, 195.0f, 250.0f, 50.0f)];
    //[self.fieldsBackground setFrame:CGRectMake(35.0f, 145.0f, 250.0f, 100.0f)];
    
    //[self.logInView.logInButton setTitle:@"登入" forState:UIControlStateNormal];
    //[self.logInView.logInButton setTitle:@"登入" forState:UIControlStateHighlighted];
    //[self.logInView.logInButton setFrame:CGRectMake(35.0f, 240.0f, 250.0f, 40.0f)];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
